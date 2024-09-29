module sonar_fd (
  input wire         clock,
  input wire         reset,
  input wire         echo,
  input wire         partida_serial,
  input wire         zera_timer,
  input wire         conta_timer,
  input wire         zera_posicao,
  input wire         conta_posicao,
  input wire         reset_servo,
  input wire         medir,
  input wire         zera_serial,
  input wire         conta_serial,
  output wire        trigger,
  output wire        pronto_medida,
  output wire        pronto_serial,
  output wire [11:0] distancia,
  output wire [23:0] angulo, 
  output wire        saida_serial,
  output wire        fim_timer,
  output wire        pwm,
  output wire        fim_transmissao,
  // Depurações internas
  output wire        db_reset_sensor,
  output wire        db_medir_sensor,
  output wire [3:0]  db_estado_sensor,

  output wire        db_tick_uart,
  output wire        db_partida_uart,
  output wire        db_saida_serial_uart,
  output wire [3:0]  db_estado_uart,

  output wire        db_reset_servo,
  output wire [2:0]  db_posicao_servo,
  output wire        db_controle_servo


);

  // Sinais internos
  wire [11:0] s_medida;
  wire [6:0]  centena_ascii_m;
  wire [6:0]  dezena_ascii_m;
  wire [6:0]  unidade_ascii_m;

  wire [23:0] s_angulo;
  wire [6:0]  centena_ascii_a;
  wire [6:0]  dezena_ascii_a;
  wire [6:0]  unidade_ascii_a;

  wire [6:0]  dados_ascii;
  wire [2:0]  endereco_pos;
  
  wire [3:0]  s_sel_letra;
  

  // Interface hcsr04 (sensor de distância)
  interface_hcsr04 sensor (
    .clock     (clock         ),
    .reset     (reset_servo   ),
    .medir     (medir         ),
    .echo      (echo          ),
    .trigger   (trigger       ),
    .medida    (s_medida      ),
    .pronto    (pronto_medida ),
    .db_reset  (db_reset_sensor ),
    .db_medir  (db_medir_sensor ),
    .db_estado (db_estado_sensor)
  );

   // Contador updown
  contadorg_updown_m #(
    .M(8),
    .N(3)
  ) contador_posicao (
    .clock   (clock),
    .zera_as (1'b0 ),
    .zera_s  (zera_posicao ),
    .conta   (conta_posicao),
    .Q       (endereco_pos ),
    .inicio  (        ),
    .fim     (        ),
    .meio    (        ),
    .direcao (        )
  );

  assign centena_ascii_m  = {3'b011, s_medida[11:8]};
  assign dezena_ascii_m   = {3'b011, s_medida[7:4] };
  assign unidade_ascii_m  = {3'b011, s_medida[3:0] };
  assign distancia        = s_medida;

  assign centena_ascii_a  = s_angulo[22:16];
  assign dezena_ascii_a   = s_angulo[14:8];
  assign unidade_ascii_a  = s_angulo[6:0];
  assign angulo           = s_angulo;
  

  // Multiplexador 4x1
  mux_8x1_n  #(
  .BITS(7)
  ) mux (
    .D7          ( 7'b0100011),
    .D6          ( unidade_ascii_m),
    .D5          ( dezena_ascii_m ),
    .D4          ( centena_ascii_m ),
    .D3          ( 7'b0101100),
    .D2          ( unidade_ascii_a ),
    .D1          ( dezena_ascii_a ),
    .D0          ( centena_ascii_a ),
    .SEL         ( sel_letra ),
    .MUX_OUT     ( dados_ascii ) 
  );

  // Transmissão serial
  tx_serial_7O1 uart (
    .clock           ( clock          ),
    .reset           ( reset          ),
    .partida         ( partida_serial ), 
    .dados_ascii     ( dados_ascii    ),
    .saida_serial    ( saida_serial   ), 
    .pronto          ( pronto_serial  ),
    .db_tick         ( db_tick_uart   ),
    .db_partida      ( db_partida_uart),
    .db_saida_serial ( db_saida_serial_uart),
    .db_estado       ( db_estado_uart )
  );

  // Servo motor
  controle_servo_3 servo (
    .clock     (clock       ),
    .reset     (reset_servo ),
    .posicao   (endereco_pos), 
    .controle  (pwm    ),
    .db_reset  (db_reset_servo ),
    .db_posicao( db_posicao_servo),
    .db_controle(db_controle_servo)
  );

  // Conatdor de qual dado vai ser transmitido
  contador_m #(
        .M(9),
        .N(4)
  ) contador_serial (
        .clock   (clock),
        .zera_as (1'b0 ),
        .zera_s  (zera_serial),
        .conta   (conta_serial),
        .Q       (s_sel_letra  ), // porta Q em aberto (desconectada)
        .fim     (fim_transmissao ),
        .meio    (     )  // porta meio em aberto (desconectada)
    );

    wire [2:0] sel_letra;
    assign sel_letra = s_sel_letra[2:0];

  
  // Contador de 2s
  // 2s = 100000000 clocks para clock de 50MHz
    contador_m #(
        .M(100_000_000),
        .N(27)
    ) timer (
        .clock   (clock),
        .zera_as (1'b0 ),
        .zera_s  (zera_timer),
        .conta   (conta_timer),
        .Q       (     ), // porta Q em aberto (desconectada)
        .fim     (fim_timer  ),
        .meio    (     )  // porta meio em aberto (desconectada)
    );

  // ROM 
  rom_angulos_8x24 rom (
      .endereco  (endereco_pos),
      .saida (s_angulo)
  );
  

endmodule
