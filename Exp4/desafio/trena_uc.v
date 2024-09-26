
module trena_uc ( 
    input      clock          ,
    input      reset          ,
    input      mensurar       ,
    input      pronto_medida  ,
    input      pronto_serial  ,
	 input      modo_auto      ,
	 input      fim_auto       ,
    output reg partida_serial ,
    output reg pronto         ,
    output reg [1:0] sel_letra,
    output reg [3:0] db_estado,
	 output reg zera_auto,
	 output reg conta_auto
);

    // Estados da UC
    parameter inicial           = 4'b0000; 
    parameter aguarda_medida    = 4'b0001; 
    parameter transmite_centena = 4'b0010; 
    parameter espera_centena    = 4'b0011; 
    parameter transmite_dezena  = 4'b0100; 
    parameter espera_dezena     = 4'b0101; 
    parameter transmite_unidade = 4'b0110; 
    parameter espera_unidade    = 4'b0111; 
    parameter transmite_hash    = 4'b1000;
    parameter espera_hash       = 4'b1001; 
	 parameter automatico        = 4'b1010; 
    parameter final             = 4'b1111;

    // Variaveis de estado
    reg [3:0] Eatual, Eprox;

    // Memoria de estado
    always @(posedge clock or posedge reset) begin
      if (reset)
        Eatual <= inicial;
      else
        Eatual <= Eprox;
    end

    // Logica de proximo estado
    always @* begin
        case (Eatual)
            inicial          : Eprox = modo_auto ? automatico : mensurar ? aguarda_medida : inicial;
				automatico 		  : Eprox = fim_auto ? aguarda_medida : automatico;
            aguarda_medida   : Eprox = pronto_medida ? transmite_centena : aguarda_medida;
            transmite_centena: Eprox = espera_centena; 
            espera_centena   : Eprox = pronto_serial ? transmite_dezena : espera_centena;
            transmite_dezena : Eprox = espera_dezena; 
            espera_dezena    : Eprox = pronto_serial ? transmite_unidade : espera_dezena;
            transmite_unidade: Eprox = espera_unidade;
            espera_unidade   : Eprox = pronto_serial ? transmite_hash : espera_unidade;
            transmite_hash   : Eprox = espera_hash; 
            espera_hash      : Eprox = pronto_serial ? final : espera_hash;
            final            : Eprox = inicial;
            default          : Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina de Moore)
    always @* begin
        partida_serial = (Eatual == transmite_centena || Eatual == transmite_dezena || 
                          Eatual == transmite_unidade || Eatual == transmite_hash ) ? 1'b1 : 1'b0;
        pronto  = (Eatual == final) ? 1'b1 : 1'b0;
		  zera_auto = (Eatual == inicial) ? 1'b1 : 1'b0;
		  conta_auto = (Eatual == automatico) ? 1'b1 : 1'b0;

        // Casos do Multiplexador 4x1 
        case(Eatual) 
            transmite_centena: sel_letra = 2'b00; 
				espera_centena: sel_letra = 2'b00;
            transmite_dezena: sel_letra = 2'b01;
				espera_dezena: sel_letra = 2'b01;
            transmite_unidade: sel_letra = 2'b10;
				espera_unidade: sel_letra = 2'b10;
            transmite_hash  : sel_letra = 2'b11;
				espera_hash  : sel_letra = 2'b11;
            default          : sel_letra = 2'b00;
        endcase
        
        // Saida de depuracao (estado)
        case (Eatual)
            inicial          : db_estado = 4'b0000; // 0
            aguarda_medida   : db_estado = 4'b0001; // 1
            transmite_centena: db_estado = 4'b0010; // 2
            espera_centena   : db_estado = 4'b0011; // 3
            transmite_dezena : db_estado = 4'b0100; // 4
            espera_dezena    : db_estado = 4'b0101; // 5
            transmite_unidade: db_estado = 4'b0110; // 6
            espera_unidade   : db_estado = 4'b0111; // 7
            transmite_hash   : db_estado = 4'b1000; // 8
            espera_hash      : db_estado = 4'b1001; // 9
				automatico       : db_estado = 4'b1010; // A
            final            : db_estado = 4'b1111; // F
            default          : db_estado = 4'b1110; // E
        endcase
    end
endmodule
