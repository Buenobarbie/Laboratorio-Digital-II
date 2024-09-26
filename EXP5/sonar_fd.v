module sonar_fd (
  input wire         clock,
  input wire         reset,
  input wire         echo,
  input wire         partida_serial,
  input wire  [2:0]  sel_letra,
  input wire         zera_timer,
  input wire         conta_timer,
  input wire         zera_posicao,
  input wire         conta_posicao,
  input wire         reset_servo,
  input wire         medir,
  output wire        trigger,
  output wire        pronto_medida,
  output wire        pronto_serial,
  output wire [11:0] distancia,
  output wire [11:0] angulo, 
  output wire        saida_serial
);

  // Sinais internos
  wire [11:0] s_medida;
  wire [6:0]  centena_ascii_m;
  wire [6:0]  dezena_ascii_m;
  wire [6:0]  unidade_ascii_m;

  wire [11:0] s_angulo;
  wire [6:0]  centena_ascii_a;
  wire [6:0]  dezena_ascii_a;
  wire [6:0]  unidade_ascii_a;

  wire [6:0]  dados_ascii;
  wire [2:0]  endereco_pos;
  


  // Interface hcsr04
  interface_hcsr04 sensor (
    .clock     (clock         ),
    .reset     (reset_servo   ),
    .medir     (medir         ),
    .echo      (echo          ),
    .trigger   (trigger       ),
    .medida    (s_medida      ),
    .pronto    (pronto_medida ),
    .db_reset  (              ),
    .db_medir  (              ),
    .db_estado (              )
  );

  assign centena_ascii_m  = {3'b011, s_medida[11:8]};
  assign dezena_ascii_m   = {3'b011, s_medida[7:4] };
  assign unidade_ascii_m  = {3'b011, s_medida[3:0] };
  assign distancia        = s_medida;

  assign centena_ascii_a  = {3'b011, s_angulo[11:8]};
  assign dezena_ascii_a   = {3'b011, s_angulo[7:4] };
  assign unidade_ascii_a  = {3'b011, s_angulo[3:0] };
  assign angulo        = s_angulo;
  

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
    .db_tick         (      ),
    .db_partida      (      ),
    .db_saida_serial (      ),
    .db_estado       (      )
  );

  
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

  // Contador updown
  contador_updown #(
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
  
  // ROM 
  rom_angulos_8x24 rom (
      .input  (endereco_pos),
      .output (s_angulo)
  );
  

endmodule
