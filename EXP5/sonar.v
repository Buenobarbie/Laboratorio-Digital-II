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
    wire        s_ligar;
    wire        s_trigger;
    wire        s_partida_serial;
    wire        s_pronto_medida;
    wire        s_pronto_serial;
    wire [11:0] s_medida ;
    wire [3:0]  s_estado ;
	 
	wire        s_zera_auto;
	wire        s_conta_auto;
	wire        s_fim_auto;
    
    // Trata entrada mensurar (considerando borda de subida)
    // ATENÇÃO: ATIVO EM ZERO
    edge_detector DB ( 
        .clock( clock  ),
        .reset( reset  ),
        .sinal( ~ligar ), 
        .pulso( s_ligar)
    );

    // Fluxo de dados
    trena_fd U0 (
        .clock          ( clock      ),
        .reset          ( reset      ),
        .echo           ( echo       ),
        .partida_serial ( s_partida_serial ),
        .zera_timer     (  ),
        .conta_timer    (  ),
        .zera_posicao   (  ),
        .conta_posicao  (  ),
        .reset_servo    (  ),
        .medir          (  ),
        .zera_serial    (  ),
        .conta_serial   (  ),
        .trigger        (    ),
        .pronto_medida  ( s_pronto_medida ),
        .pronto_serial  ( s_pronto_serial ),
        .distancia      (  ),
        .angulo         (  ),
        .saida_serial   ( saida_serial),
        .fim_timer      (   ),
        .pwm            (   ),
        .fim_transmissao(   ),
        .db_reset_sensor     ( db_reset_sensor ),
        .db_medir_sensor     ( db_medir_sensor ),
        .db_estado_sensor    ( db_estado_sensor ),
        .db_tick_uart        ( db_tick_uart ),
        .db_partida_uart     ( db_partida_uart ),
        .db_saida_serial_uart( db_saida_serial_uart ),
        .db_estado_uart      ( db_estado_uart ),
        .db_reset_servo      ( db_reset_servo ),
        .db_posicao_servo    ( db_posicao_servo ),
        .db_controle_servo   ( db_controle_servo )
    );

    // Unidade de controle
    trena_uc U1 (
        .clock         ( clock      ),
        .reset         ( reset      ),
        .ligar         ( ligar      ),
        .pronto_medida ( s_pronto_medida ),
        .fim_timer     ( s_fim_auto),
        .pronto_serial ( s_pronto_serial ),
        .fim_transmissao( s_fim_auto),
        .partida_serial( s_partida_serial ),
        .db_estado     ( s_estado ),
        .zera_timer    ( s_zera_auto),
        .conta_timer   ( s_conta_auto),
        .zera_posicao  ( s_zera_auto),
        .conta_posicao ( s_conta_auto),
        .reset_servo   ( s_zera_auto),
        .medir         ( s_mensurar ),
        .zera_serial   ( s_zera_auto),
        .conta_serial  ( s_conta_auto)
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
