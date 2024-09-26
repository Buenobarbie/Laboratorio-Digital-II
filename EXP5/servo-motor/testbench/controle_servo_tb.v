/* --------------------------------------------------------------------
 * Arquivo   : controle_servo_tb.v
 *
 * testbench basico para o componente controle_servo
 *
 * ------------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     26/09/2021  1.0     Edson Midorikawa  criacao do componente VHDL
 *     17/08/2024  2.0     Edson Midorikawa  componente em Verilog
 * ------------------------------------------------------------------------
 */
  
`timescale 1ns/1ns

module controle_servo_tb;

    // Declaração de sinais para conectar o componente a ser testado (DUT)
    reg       clock_in   = 1;
    reg       reset_in   = 0;
    reg [2:0] posicao_in = 3'b000;
    wire      controle_out;

    // Configuração do clock
    parameter clockPeriod = 20; // T=20ns, f=50MHz

    // Identificacao do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // Componente a ser testado (Device Under Test -- DUT)
    controle_servo           // instanciado com valores default
    dut (
        .clock       (clock_in     ),
        .reset       (reset_in     ),
        .posicao     (posicao_in   ),
        .controle    (controle_out ),
        .db_reset    (             ),
        .db_posicao  (             ),
        .db_controle (             )
    );

    // Geração dos sinais de entrada (estímulos)
    initial begin

        $display("Inicio da simulacao\n... Simulacao ate 800ms (800_000_000ns). Aguarde o final da simulacao...");

        // Teste 1. resetar circuito
        caso = 1;
        reset_in = 0;
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
        posicao_in = 3'b000; // angulo de 20 graus
        #(200_000_000);     // espera por 200ms

        // Teste 3. posicao=01
        caso = 3;
        @(negedge clock_in);
        posicao_in = 3'b001; // angulo de 40 graus
        #(200_000_000);

        // Teste 4. posicao=10
        caso = 4;
        @(negedge clock_in);
        posicao_in = 3'b010; // angulo de 60 graus
        #(200_000_000);

        // Teste 5. posicao=11
        caso = 5;
        @(negedge clock_in);
        posicao_in = 3'b011; // angulo de 80 graus
        #(200_000_000);

        // Teste 6. posicao=100
        caso = 6;
        @(negedge clock_in);
        posicao_in = 3'b100; // angulo de 100 graus
        #(200_000_000);
        
        // Teste 7. posicao=101
        caso = 7;
        @(negedge clock_in);
        posicao_in = 3'b101; // angulo de 120 graus
        #(200_000_000);

        // Teste 8. posicao=110
        caso = 8;
        @(negedge clock_in);
        posicao_in = 3'b110; // angulo de 140 graus
        #(200_000_000);

        // Teste 9. posicao=111
        caso = 9;
        @(negedge clock_in);
        posicao_in = 3'b111; // angulo de 160 graus
        #(200_000_000);


        // final dos casos de teste da simulacao
        caso = 99;
        #100;
        $display("Fim da simulacao");
        $stop;
    end

endmodule