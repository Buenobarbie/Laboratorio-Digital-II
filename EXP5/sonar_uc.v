
module sonar_uc ( 
    input      clock,
    input      reset,
    input      ligar,
    input      pronto_medida,
    input      fim_timer, 
    input      pronto_serial,
    input      fim_transmissao,
    output reg partida_serial,
    output reg fim_posicao,
    output reg [3:0] db_estado,
	 output reg zera_timer,
    output reg conta_timer,
    output reg zera_posicao,
    output reg conta_posicao,
    output reg reset_servo,
    output reg medir,
    output reg zera_serial,
    output reg conta_serial
);

    // Estados da UC
    parameter inicial              = 4'b0000;  // 0
    parameter preparacao           = 4'b0001;  // 1
    parameter espera               = 4'b0010;  // 2
    parameter aguarda_medida       = 4'b0011;  // 3
    parameter transmite_serial     = 4'b0100;  // 4
    parameter espera_serial        = 4'b0101;  // 5
    parameter atualiza_serial      = 4'b0110;  // 6
    parameter atualiza_posicao     = 4'b0111;  // 7
    

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
            aguarda_medida      : Eprox = pronto_medida ? transmite_serial : aguarda_medida;
            transmite_serial    : Eprox = espera_serial;
            espera_serial       : Eprox = pronto_serial ? atualiza_serial : espera_serial; 
            atualiza_serial     : Eprox = fim_transmissao ? atualiza_posicao : transmite_serial;
            atualiza_posicao    : Eprox = espera;
            default             : Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina de Moore)
    always @* begin
        zera_timer     = (Eatual == preparacao) ? 1'b1 : 1'b0;
        zera_posicao   = (Eatual == preparacao) ? 1'b1 : 1'b0;
        zera_serial    = (Eatual == preparacao ||
                          Eatual == atualiza_posicao) ? 1'b1 : 1'b0;
        reset_servo    = (Eatual == preparacao) ? 1'b1 : 1'b0;
        conta_timer    = (Eatual == espera) ? 1'b1 : 1'b0;
        medir          = (Eatual == aguarda_medida) ? 1'b1 : 1'b0;
        partida_serial = (Eatual == transmite_serial) ? 1'b1 : 1'b0;
        conta_serial   = (Eatual == atualiza_serial) ? 1'b1 : 1'b0;
        conta_posicao  = (Eatual == atualiza_posicao) ? 1'b1 : 1'b0;
        fim_posicao    = (Eatual == atualiza_posicao) ? 1'b1 : 1'b0;
        
        // Saida de depuracao (estado)
        case (Eatual)
            inicial             : db_estado = 4'b0000; // 0
            preparacao          : db_estado = 4'b0001; // 1
            espera              : db_estado = 4'b0010; // 2
            aguarda_medida      : db_estado = 4'b0011; // 3
            transmite_serial    : db_estado = 4'b0100; // 4
            espera_serial       : db_estado = 4'b0101; // 5
            atualiza_serial     : db_estado = 4'b0110; // 6
            atualiza_posicao    : db_estado = 4'b0111; // 7
            default             : db_estado = 4'b0000;
            
        endcase
    end
endmodule
