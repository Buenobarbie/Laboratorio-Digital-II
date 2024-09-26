module trena_fd (
  input wire         clock,
  input wire         reset,
  input wire         mensurar,
  input wire         echo,
  input wire         partida_serial,
  input wire  [1:0]  sel_letra,
  output wire        trigger,
  output wire        pronto_medida,
  output wire        pronto_serial,
  output wire [11:0] distancia,
  output wire        saida_serial
);

  // Sinais internos
  wire [11:0] s_medida;
  wire [6:0]  centena_ascii;
  wire [6:0]  dezena_ascii;
  wire [6:0]  unidade_ascii;
  wire [6:0]  dados_ascii;

  // Interface hcsr04
  interface_hcsr04 U1 (
    .clock     (clock         ),
    .reset     (reset         ),
    .medir     (mensurar      ),
    .echo      (echo          ),
    .trigger   (trigger       ),
    .medida    (s_medida      ),
    .pronto    (pronto_medida ),
    .db_estado ()
  );

  assign centena_ascii  = {3'b011, s_medida[11:8]};
  assign dezena_ascii   = {3'b011, s_medida[7:4] };
  assign unidade_ascii  = {3'b011, s_medida[3:0] };
  assign distancia      = s_medida;

  // Multiplexador 4x1
  mux_4x1_n  #(
  .BITS(7)
  ) U2 (
    .D3          ( 7'b0010111),
    .D2          ( unidade_ascii ),
    .D1          ( dezena_ascii ),
    .D0          ( centena_ascii ),
    .SEL         ( sel_letra ),
    .MUX_OUT     ( dados_ascii ) 
  );

  // Transmissão serial
  tx_serial_7O1 U3 (
    .clock           ( clock          ),
    .reset           ( reset          ),
    .partida         ( partida_serial ), 
    .dados_ascii     ( dados_ascii    ),
    .saida_serial    ( saida_serial   ), 
    .pronto          ( pronto_serial  ),
    .db_clock        (      ), 
    .db_tick         (      ),
    .db_partida      (      ),
    .db_saida_serial (      ),
    .db_estado       (      )
  );


endmodule
