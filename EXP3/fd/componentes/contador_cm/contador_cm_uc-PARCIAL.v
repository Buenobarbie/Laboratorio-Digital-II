/* --------------------------------------------------------------------------
 *  Arquivo   : contador_cm_uc-PARCIAL.v
 * --------------------------------------------------------------------------
 *  Descricao : unidade de controle do componente contador_cm
 *              
 *              incrementa contagem de cm a cada sinal de tick enquanto
 *              o pulso de entrada permanece ativo
 *              
 * --------------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      07/09/2024  1.0     Edson Midorikawa  versao em Verilog
 * --------------------------------------------------------------------------
 */

module contador_cm_uc (
    input wire clock,
    input wire reset,
    input wire pulso,
    output reg zera_tick,
    output reg conta_tick,
    output reg zera_bcd,
    output reg pronto,
    output reg [2:0] db_estado
);

    // Tipos e sinais
    reg [2:0] Eatual, Eprox; // 3 bits são suficientes para os estados

    // Parâmetros para os estados
    parameter inicial = 3'b000;
    parameter medicao = 3'b001;
    parameter fim = 3'b010;

    // Memória de estado
    always @(posedge clock, posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox; 
    end

    // Lógica de próximo estado
    always @(*) begin
        case (Eatual)
            inicial : Eprox = pulso ? medicao : inicial;
            medicao : Eprox = pulso ? medicao : fim;
            fim: Eprox = inicial;
            default : Eprox = inicial;
        endcase
    end

    // Lógica de saída (Moore)
    always @(*) begin
        zera_tick = (Eatual == inicial) ? 1'b1 : 1'b0;
        conta_tick = (Eatual == medicao) ? 1'b1 : 1'b0;
        zera_bcd = (Eatual == inicial) ? 1'b1 : 1'b0;
        pronto = (Eatual == fim) ? 1'b1 : 1'b0;

        case (Eatual)
            inicial : db_estado = 3'b000;
            medicao : db_estado = 3'b001;
            fim : db_estado = 3'b010;
            default : db_estado = 3'b000;
        endcase
    end

endmodule