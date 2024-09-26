
module sonar_uc ( 
    input      clock          ,
    input      reset          ,
    input      ligar       ,
    input      pronto_medida  ,
    input      fim_timer, 
    input      pronto_serial  ,
    output reg partida_serial ,
    output reg pronto_posicao ,
    output reg [2:0] sel_letra,
    output reg [4:0] db_estado,
	output reg zera_timer,
    output reg conta_timer ,
    output reg zera_posicao,
    output reg conta_posicao,
    output reg reset_servo
);

    // Estados da UC
    parameter inicial              = 5'b00000;  // 0
    parameter preparacao           = 5'b00001;  // 1
    parameter espera               = 5'b00010;  // 2
    parameter aguarda_medida       = 5'b00011;  // 3
    parameter transmite_centena_a  = 5'b00100;  // 4
    parameter espera_centena_a     = 5'b00101;  // 5
    parameter transmite_dezena_a   = 5'b00110;  // 6
    parameter espera_dezena_a      = 5'b00111;  // 7
    parameter transmite_unidade_a  = 5'b01000;  // 8
    parameter espera_unidade_a     = 5'b01001;  // 9
    parameter transmite_virgula    = 5'b01010;  // A
    parameter espera_virgula       = 5'b01011;  // B
    parameter transmite_centena_m  = 5'b01100;  // C
    parameter espera_centena_m     = 5'b01101;  // D
    parameter transmite_dezena_m   = 5'b01110;  // E
    parameter espera_dezena_m      = 5'b01111;  // F
    parameter transmite_unidade_m  = 5'b10000;  // 10
    parameter espera_unidade_m     = 5'b10001;  // 11
    parameter transmite_hash       = 5'b10010;  // 12
    parameter espera_hash          = 5'b10011;  // 13
    parameter atualiza_posicao     = 5'b10100;  // 14
    

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
            inicial             : Eprox = ligar ? preparacao : inicial;
            preparacao          : Eprox = espera;
            espera              : Eprox = ~ligar ? inicial : (fim_timer ? aguarda_medida : espera);
            aguarda_medida      : Eprox = pronto_medida ? transmite_centena_a : aguarda_medida;
            
            // Transmite Angulo
            transmite_centena_a : Eprox = espera_centena_a;
            espera_centena_a    : Eprox = pronto_serial ? transmite_dezena_a : espera_centena_a;
            transmite_dezena_a  : Eprox = espera_dezena_a;   
            espera_dezena_a     : Eprox = pronto_serial ? transmite_unidade_a : espera_dezena_a;  
            transmite_unidade_a : Eprox = espera_unidade_a;
            espera_unidade_a    : Eprox = pronto_serial ? transmite_virgula : espera_unidade_a;
            
            // Transmite Virgula
            transmite_virgula   : Eprox = espera_virgula;
            espera_virgula      : Eprox = pronto_serial ? transmite_centena_m : espera_virgula;
            
            // Transmite Medida
            transmite_centena_m : Eprox = espera_centena_m;
            espera_centena_m    : Eprox = pronto_serial ? transmite_dezena_m : espera_centena_m;
            transmite_dezena_m  : Eprox = espera_dezena_m;
            espera_dezena_m     : Eprox = pronto_serial ? transmite_unidade_m : espera_dezena_m;
            transmite_unidade_m : Eprox = espera_unidade_m;
            espera_unidade_m    : Eprox = pronto_serial ? transmite_hash : espera_unidade_m;
            
            // Transmite Hash
            transmite_hash      : Eprox = espera_hash;
            espera_hash         : Eprox = pronto_serial ? atualiza_posicao : espera_hash;
            
            atualiza_posicao    : Eprox = espera;
            default             : Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina de Moore)
    always @* begin
        zera_timer = (Ea)
        
        
        partida_serial = (Eatual == transmite_centena || Eatual == transmite_dezena || 
                          Eatual == transmite_unidade || Eatual == transmite_hash ) ? 1'b1 : 1'b0;
        pronto  = (Eatual == final) ? 1'b1 : 1'b0;
		zera_auto = (Eatual == inicial) ? 1'b1 : 1'b0;
		conta_auto = (Eatual == automatico) ? 1'b1 : 1'b0;

        // Casos do Multiplexador 4x1 
        case(Eatual) 
            transmite_centena_a: sel_letra = 3'b000; 
			espera_centena_a: sel_letra    = 3'b000;
            transmite_dezena_a: sel_letra  = 3'b001;
			espera_dezena_a: sel_letra     = 3'b001;
            transmite_unidade_a: sel_letra = 3'b010;
			espera_unidade_a: sel_letra    = 3'b010;
            
            transmite_virgula: sel_letra   = 3'b011;
            espera_virgula: sel_letra      = 3'b011;

            transmite_centena_m: sel_letra = 3'b100;
            espera_centena_m: sel_letra    = 3'b100;
            transmite_dezena_m: sel_letra  = 3'b101;
            espera_dezena_m: sel_letra     = 3'b101;
            transmite_unidade_m: sel_letra = 3'b110;
            espera_unidade_m: sel_letra    = 3'b110;
            
            transmite_hash: sel_letra       = 3'b111;
            espera_hash: sel_letra          = 3'b111;
            
            default          : sel_letra = 3'b000;
        endcase
        
        // Saida de depuracao (estado)
        case (Eatual)
            inicial             : db_estado = 5'b00000;
            preparacao          : db_estado = 5'b00001;
            espera              : db_estado = 5'b00010;
            aguarda_medida      : db_estado = 5'b00011;
            transmite_centena_a : db_estado = 5'b00100;
            espera_centena_a    : db_estado = 5'b00101;
            transmite_dezena_a  : db_estado = 5'b00110;
            espera_dezena_a     : db_estado = 5'b00111;
            transmite_unidade_a : db_estado = 5'b01000;
            espera_unidade_a    : db_estado = 5'b01001;
            transmite_virgula   : db_estado = 5'b01010; 
            espera_virgula      : db_estado = 5'b01011;
            transmite_centena_m : db_estado = 5'b01100;
            espera_centena_m    : db_estado = 5'b01101;
            transmite_dezena_m  : db_estado = 5'b01110;
            espera_dezena_m     : db_estado = 5'b01111;
            transmite_unidade_m : db_estado = 5'b10000;
            espera_unidade_m    : db_estado = 5'b10001;
            transmite_hash      : db_estado = 5'b10010;
            espera_hash         : db_estado = 5'b10011;
            atualiza_posicao    : db_estado = 5'b10100;
            default             : db_estado = 5'b00000;
            
        endcase
    end
endmodule
