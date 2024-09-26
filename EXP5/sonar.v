module sonar (
    input wire        clock,
    input wire        reset,
    input wire        ligar,
    input wire        echo,
    output wire       trigger,
    output wire       saida_serial,
    output wire       pwm,
    output wire       saida_serial,
    output wire       fim_posicao,
    output wire [6:0] db_estado,
    output wire       db_echo,
    output wire       db_trigger,
    output wire       db_pwm,
    output wire       db_posicao_servo
    
);

    // Sinais internos
    wire        s_mensurar;
    wire        s_trigger;
    wire        s_partida_serial;
    wire        s_pronto_medida;
    wire        s_pronto_serial;
    wire [1:0]  s_sel_letra;
    wire [11:0] s_medida ;
    wire [3:0]  s_estado ;
	 
	 wire        s_zera_auto;
	 wire        s_conta_auto;
	 wire        s_fim_auto;
    
    // Trata entrada mensurar (considerando borda de subida)
    edge_detector DB ( 
        .clock( clock      ),
        .reset( reset      ),
        .sinal( ~mensurar   ), 
        .pulso( s_mensurar )
    );

    // Fluxo de dados
    trena_fd U0 (
        .clock         ( clock      ),
        .reset         ( reset      ),
        .mensurar      ( s_mensurar ),
        .echo          ( echo       ),
        .partida_serial( s_partida_serial ),
        .sel_letra     ( s_sel_letra ),
        .trigger       ( s_trigger),
		  .conta_auto    ( s_conta_auto),
		  .zera_auto     ( s_zera_auto),
        .pronto_medida ( s_pronto_medida ),
        .pronto_serial ( s_pronto_serial ),
        .distancia     ( s_medida ),
        .saida_serial  ( saida_serial ),
		  .fim_auto      (s_fim_auto)
    );

    // Unidade de controle
    trena_uc U1 (
        .clock         ( clock      ),
        .reset         ( reset      ),
        .mensurar      ( s_mensurar ),
        .pronto_medida ( s_pronto_medida ),
        .pronto_serial ( s_pronto_serial ),
		  .modo_auto     ( modo_auto),
		  .fim_auto      ( s_fim_auto),
        .partida_serial( s_partida_serial ),
        .pronto        ( pronto ),
        .sel_letra     ( s_sel_letra ),
        .db_estado     ( s_estado ),
		  .conta_auto    ( s_conta_auto),
		  .zera_auto     ( s_zera_auto)
    );

    // Displays para medida (4 dígitos BCD)
    hexa7seg H0 (
        .hexa   (s_medida[3:0]), 
        .display(medida0         )
    );
    hexa7seg H1 (
        .hexa   (s_medida[7:4]), 
        .display(medida1       )
    );
    hexa7seg H2 (
        .hexa   (s_medida[11:8]), 
        .display(medida2          )
    );

    // Sinais de saída
    assign trigger = s_trigger;

    // Sinal de depuração (estado da UC)
    hexa7seg H5 (
        .hexa   (s_estado ), 
        .display(db_estado)
    );

    assign db_echo    = echo;
    assign db_trigger = s_trigger;
endmodule
