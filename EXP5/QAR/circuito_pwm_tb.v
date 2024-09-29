/* --------------------------------------------------------------------
 * Arquivo   : circuito_pwm_tb.v
 *
 * testbench basico para o componente circuito_pwm
 *
 * ------------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     26/09/2021  1.0     Edson Midorikawa  criacao do componente VHDL
 *     17/08/2024  2.0     Edson Midorikawa  componente em Verilog
 * ------------------------------------------------------------------------
 */
  
`timescale 1ns/1ns

module circuito_pwm_tb;

    // Declaração de sinais para conectar o componente a ser testado (DUT)
    reg       clock_in   = 1;
    reg       reset_in   = 0;
    reg [2:0] largura_in = 3'b000;
    wire      pwm_out;

    // Configuração do clock
    parameter clockPeriod = 20; // T=20ns, f=50MHz

    // Identificacao do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // Componente a ser testado (Device Under Test -- DUT)
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

      ) dut (
        .clock   (clock   ),
        .reset   (reset   ),
        .largura (posicao ),
        .pwm     (controle)
    );

    // Geração dos sinais de entrada (estímulos)
    initial begin

        $display("Inicio da simulacao\n... Simulacao ate 800 us. Aguarde o final da simulacao...");

        // Teste 1. resetar circuito
        caso = 1;
        // gera pulso de reset
        @(negedge clock_in);
        reset_in = 1;
        #(clockPeriod);
        reset_in = 0;
        // espera
        #(10*clockPeriod);

        // Teste 2. posicao=00
        caso = 2;
        @(negedge clock_in);
        largura_in = 3'b000; // angulo de 20°
        #(200_000);         // espera por 200us

        // Teste 3. posicao=01
        caso = 3;
        @(negedge clock_in);
        largura_in = 3'b001; // angulo de 40°
        #(200_000); 

        // Teste 4. posicao=10
        caso = 4;
        @(negedge clock_in);
        largura_in = 3'b010; // angulo de 60°
        #(200_000);

        // Teste 5. posicao=11
        caso = 5;
        @(negedge clock_in);
        largura_in = 3'b011; // angulo de 80°
        #(200_000);

        // Teste 6. posicao=100
        caso = 6;
        @(negedge clock_in);
        largura_in = 3'b100; // angulo de 100°
        #(200_000);

        // Teste 7. posicao=101
        caso = 7;
        @(negedge clock_in);
        largura_in = 3'b101; // angulo de 120°
        #(200_000);

        // Teste 8. posicao=110
        caso = 8;
        @(negedge clock_in);
        largura_in = 3'b110; // angulo de 140°
        #(200_000);

        // Teste 9. posicao=111
        caso = 9;
        @(negedge clock_in);
        largura_in = 3'b111; // angulo de 160°
        #(200_000);


        // final dos casos de teste da simulacao
        caso = 99;
        #100;
        $display("Fim da simulacao");
        $stop;
    end

endmodule