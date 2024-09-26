module controle_servo_3 (
    input wire clock,
    input wire reset,
    input wire [2:0] posicao,
    output wire controle,
    output wire db_reset,
    output wire [2:0] db_posicao,
    output wire db_controle
);

      // 50.000 -> 0°
      // 100.000 -> 180°

      circuito_pwm #(           
        .conf_periodo (1000000), // 20ms = 20ms / 2ns = 1000000 
        .largura_000  (55556), // 20° => (100.000-50.000)/180° * 20° + 50.000 = 55.556
        .largura_001  (61111), // 40° => (100.000-50.000)/180° * 40° + 50.000 = 61.111
        .largura_010  (66667), // 60° => (100.000-50.000)/180° * 60° + 50.000 = 66.667
        .largura_011  (72222), // 80° => (100.000-50.000)/180° * 80° + 50.000 = 72.222
        .largura_100  (77778), // 100° => (100.000-50.000)/180° * 100° + 50.000 = 77.778
        .largura_101  (83333), // 120° => (100.000-50.000)/180° * 120° + 50.000 = 83.333
        .largura_110  (88889), // 140° => (100.000-50.000)/180° * 140° + 50.000 = 88.889
        .largura_111  (94444) // 160° => (100.000-50.000)/180° * 160° + 50.000 = 94.444

      ) controle_servo (
        .clock   (clock   ),
        .reset   (reset   ),
        .largura (posicao ),
        .pwm     (controle)
    );

    assign db_reset = reset;
    assign db_posicao = posicao;
    assign db_controle = controle;

endmodule