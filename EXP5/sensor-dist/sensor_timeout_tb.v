// Teste com timeout no recebimento do echo
 
`timescale 1ns/1ns

module interface_hcsr04_tb;

    // Declaração de sinais
    reg         clock_in = 0;
    reg         reset_in = 0;
    reg         medir_in = 0;
    reg         echo_in = 0;
    wire        trigger_out;
    wire [11:0] medida_out;
    wire        pronto_out;
    wire [3:0]  db_estado_out;
    wire        db_reset_out;
    wire        db_medir_out;

    // Componente a ser testado (Device Under Test -- DUT)
    interface_hcsr04 dut (
        .clock    (clock_in     ),
        .reset    (reset_in     ),
        .medir    (medir_in     ),
        .echo     (echo_in      ),
        .trigger  (trigger_out  ),
        .medida   (medida_out   ),
        .pronto   (pronto_out   ),
        .db_reset (db_reset_out ),
        .db_medir (db_medir_out ),
        .db_estado(db_estado_out)
    );

    // Configurações do clock
    parameter clockPeriod = 20; // clock de 50MHz
    // Gerador de clock
    always #(clockPeriod/2) clock_in = ~clock_in;

    // Array de casos de teste (estrutura equivalente em Verilog)
    reg [31:0] casos_teste [0:3]; // Usando 32 bits para acomodar o tempo
    integer caso;

    // Largura do pulso
    reg [31:0] larguraPulso; // Usando 32 bits para acomodar tempos maiores

    // Geração dos sinais de entrada (estímulos)
    initial begin
        $display("Inicio das simulacoes");

        // Inicialização do array de casos de teste
        casos_teste[0] = 4440;   // 4440us (75,50cm) arredondar para 75cm
        casos_teste[1] = 4441;   // 4441us (75,48cm) truncar para 75cm
        casos_teste[2] = 294;    // 294us (74cm)
        casos_teste[3] = 0;      // 0us 

        // Valores iniciais
        medir_in = 0;
        echo_in  = 0;

        // Reset
        caso = 0; 
        #(2*clockPeriod);
        reset_in = 1;
        #(2_000); // 2 us
        reset_in = 0;
        @(negedge clock_in);

        // Espera de 100us
        #(100_000); // 100 us

        // Loop pelos casos de teste
        for (caso = 1; caso < 5; caso = caso + 1) begin
            // 1) Determina a largura do pulso echo
            $display("Caso de teste %0d: %0dus", caso, casos_teste[caso-1]);
            larguraPulso = casos_teste[caso-1]*1000; // 1us=1000

            // 2) Envia pulso medir
            @(negedge clock_in);
            medir_in = 1;
            #(5*clockPeriod);
            medir_in = 0;

            // 3) Espera por 400us (tempo entre trigger e echo)
            #(400_000); // 400 us

            // 4) Espera 1s (tempo para causar timeout)
            #(50_000_000); // 1 s

            // 5) Gera pulso de echo
            echo_in = 1;
            #(larguraPulso);
            echo_in = 0;

            // 6) Espera final da medida
            wait (pronto_out == 1'b1);
            $display("Fim do caso %0d", caso);

            // 6) Espera entre casos de teste
            #(100_000); // 100 us
        end

        // Fim da simulação
        $display("Fim das simulacoes");
        caso = 99; 
        $stop;
    end

endmodule
