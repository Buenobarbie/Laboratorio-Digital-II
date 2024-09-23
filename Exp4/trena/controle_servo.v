module controle_servo (
    input wire clock,
    input wire reset,
    input wire [1:0] posicao,
    output wire controle,
    output wire db_controle
);

      circuito_pwm #(           
        .conf_periodo(1000000), 
        .largura_00  (0      ), 
        .largura_01  (50000  ),  
        .largura_10  (75000 ), 
        .largura_11  (100000 )   
      ) controle_servo (
        .clock   (clock   ),
        .reset   (reset   ),
        .largura (posicao ),
        .pwm     (controle)
    );

    assign db_controle = controle;

endmodule