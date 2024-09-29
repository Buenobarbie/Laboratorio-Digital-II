module sonar (
    input wire        clock,
    input wire        reset,
    input wire        ligar,
    input wire        echo,
    output wire       trigger,
    output wire       pwm,
    output wire       saida_serial,
    output wire       fim_posicao,
    output wire [6:0] db_estado,
    output wire       db_echo,
    output wire       db_trigger,
    output wire       db_pwm,
    output wire       db_posicao_servo,
    output wire       db_reset_sensor,
    output wire       db_medir_sensor,
    output wire [6:0] db_estado_sensor,
    output wire       db_tick_uart,
    output wire       db_partida_uart,
    output wire       db_saida_serial_uart,
    output wire [6:0] db_estado_uart,
    output wire       db_reset_servo,
    output wire       db_controle_servo,
    output wire [6:0] medida0,
    output wire [6:0] medida1,
    output wire [6:0] medida2,
    output wire [6:0] angulo0,
    output wire [6:0] angulo1,
    output wire [6:0] angulo2
);

    // Sinais internos
    wire        s_ligar;
    wire        s_trigger;
    wire        s_partida_serial;
    wire        s_pronto_medida;
    wire        s_pronto_serial;
    wire [11:0] s_medida;
    wire [3:0]  s_estado;
	 
	 wire s_zera_timer;
    wire s_conta_timer;
    wire s_fim_timer;
    
    wire s_zera_posicao;
    wire s_conta_posicao;

    wire s_reset_servo;
    wire s_medir;
    
    wire s_zera_serial;
    wire s_conta_serial;
    wire s_fim_transmissao;

    wire [11:0] s_distancia;
    wire [23:0] s_angulo;
    
    // Trata entrada mensurar (considerando borda de subida)
    // ATENÇÃO: ATIVO EM ZERO
    edge_detector edge_detector ( 
        .clock( clock  ),
        .reset( reset  ),
        .sinal( ~ligar ), 
        .pulso( s_ligar)
    );

    // Fluxo de dados
    sonar_fd fd (
        .clock          ( clock ),
        .reset          ( reset ),
        .echo           ( echo  ),
        .partida_serial ( s_partida_serial ),
        .zera_timer     ( s_zera_timer   ),
        .conta_timer    ( s_conta_timer  ),
        .zera_posicao   ( s_zera_posicao ),
        .conta_posicao  ( s_conta_posicao),
        .reset_servo    ( s_reset_servo  ),
        .medir          ( s_medir),
        .zera_serial    ( s_zera_serial ),
        .conta_serial   ( s_conta_serial),
        .trigger        ( s_trigger     ),
        .pronto_medida  ( s_pronto_medida ),
        .pronto_serial  ( s_pronto_serial ),
        .distancia      ( s_distancia   ),
        .angulo         ( s_angulo    ),
        .saida_serial   ( saida_serial),
        .fim_timer      ( s_fim_timer ),
        .pwm            ( pwm  ),
        .fim_transmissao( s_fim_transmissao    ),
        .db_reset_sensor     ( db_reset_sensor ),
        .db_medir_sensor     ( db_medir_sensor ),
        .db_estado_sensor    ( db_estado_sensor),
        .db_tick_uart        ( db_tick_uart     ),
        .db_partida_uart     ( db_partida_uart  ),
        .db_saida_serial_uart( db_saida_serial_uart ),
        .db_estado_uart      ( db_estado_uart   ),
        .db_reset_servo      ( db_reset_servo   ),
        .db_posicao_servo    ( db_posicao_servo ),
        .db_controle_servo   ( db_controle_servo)
    );

    // Unidade de controle
    sonar_uc uc (
        .clock          ( clock      ),
        .reset          ( reset      ),
        .ligar          ( ligar      ),
        .pronto_medida  ( s_pronto_medida ),
        .fim_timer      ( s_fim_timer),
        .pronto_serial  ( s_pronto_serial ),
        .fim_transmissao( s_fim_transmissao ),
        .partida_serial ( s_partida_serial ),
		  .fim_posicao    ( fim_posicao ),
        .db_estado      ( s_estado ),
        .zera_timer     ( s_zera_timer),
        .conta_timer    ( s_conta_timer),
        .zera_posicao   ( s_zera_posicao),
        .conta_posicao  ( s_conta_posicao),
        .reset_servo    ( s_reset_servo),
        .medir          ( s_medir ),
        .zera_serial    ( s_zera_serial),
        .conta_serial   ( s_conta_serial)
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

    // Displays para o angulo (4 dígitos BCD)
    hexa7seg H3 (
        .hexa   (s_angulo[3:0]), 
        .display(angulo0       )
    );

    hexa7seg H4 (
        .hexa   (s_angulo[11:8]), 
        .display(angulo1       )
    );

    hexa7seg H5 (
        .hexa   (s_angulo[19:16]), 
        .display(angulo2       )
    );


    // Sinais de saída
    assign trigger = s_trigger;

    // Sinal de depuração (estado da UC)
    hexa7seg H6 (
        .hexa   (s_estado ), 
        .display(db_estado)
    );

    assign db_echo    = echo;
    assign db_trigger = s_trigger;
endmodule
