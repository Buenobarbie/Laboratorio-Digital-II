module sonar (
    input wire        clock,
    input wire        reset,
    input wire        ligar,
    input wire        echo,
    input wire        sel_display, // 0: Angulo, 1: Estados
    output wire       trigger,
    output wire       pwm,
    output wire       saida_serial,
    output wire       fim_posicao,
    output wire       db_echo,     // GPIO
    output wire       db_trigger,  // GPIO
    output wire       db_pwm,      // GPIO
    output wire [2:0] db_posicao_servo, // 3 Leds
    output wire       db_reset_sensor,  // LED
    output wire       db_medir_sensor,  // LED
    output wire       db_tick_uart,  // GPIO
    output wire       db_partida_uart, // GPIO
    output wire       db_saida_serial_uart, // GPIO
    output wire       db_reset_servo, // LED
    output wire       db_controle_servo, // GPIO
    output wire [6:0] medida0,
    output wire [6:0] medida1,
    output wire [6:0] medida2,
    output wire [6:0] H3_out,
    output wire [6:0] H4_out,
    output wire [6:0] H5_out
);

    // Sinais internos
    wire        s_ligar;
    wire        s_trigger;
    wire        s_partida_serial;
    wire        s_pronto_medida;
    wire        s_pronto_serial;
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
        .hexa   (s_distancia[3:0]), 
        .display(medida0         )
    );
    hexa7seg H1 (
        .hexa   (s_distancia[7:4]), 
        .display(medida1       )
    );
    hexa7seg H2 (
        .hexa   (s_distancia[11:8]), 
        .display(medida2          )
    );


    // Multiplexador para angulo ou db_estados
    wire H3_in;
    wire H4_in;
    wire H5_in;

    assign H3_in = sel_display ? s_estado : s_angulo[3:0];
    assign H4_in = sel_display ? db_estado_sensor : s_angulo[11:8];
    assign H5_in = sel_display ? db_estado_uart : s_angulo[19:16];

    // Displays para o angulo (4 dígitos BCD)
    hexa7seg H3 (
        .hexa   (H3_in), 
        .display(H3_out       )
    );

    hexa7seg H4 (
        .hexa   (H4_in), 
        .display(H4_out       )
    );

    hexa7seg H5 (
        .hexa   (H5_in), 
        .display(H5_out )
    );


    // Sinais de saída
    assign trigger = s_trigger;		
    assign db_echo    = echo;
    assign db_trigger = s_trigger;
	 assign db_pwm = pwm;
endmodule
