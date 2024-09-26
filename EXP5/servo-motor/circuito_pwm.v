
 
module circuito_pwm #(    // valores default
    parameter conf_periodo = 1250,  // Período do sinal PWM [1250 => f=4KHz (25us)]
    parameter largura_000   = 0,    // Largura do pulso p/ 000 [0 => 0]
    parameter largura_001   = 50,   // Largura do pulso p/ 001 [50 => 1us]
    parameter largura_010   = 500,  // Largura do pulso p/ 010 [500 => 10us]
    parameter largura_011   = 1000, // Largura do pulso p/ 011 [1000 => 20us]
    parameter largura_100   = 1500, // Largura do pulso p/ 100 [1500 => 30us]
    parameter largura_101   = 2000, // Largura do pulso p/ 101 [2000 => 40us]
    parameter largura_110   = 2500, // Largura do pulso p/ 110 [2500 => 50us]
    parameter largura_111   = 3000  // Largura do pulso p/ 111 [3000 => 60us]
) (
    input        clock,
    input        reset,
    input  [2:0] largura,
    output reg   pwm
);

reg [31:0] contagem; // Contador interno (32 bits) para acomodar conf_periodo
reg [31:0] largura_pwm;

always @(posedge clock or posedge reset) begin
    if (reset) begin
        contagem <= 0;
        pwm <= 0;
        largura_pwm <= largura_000; // Valor inicial da largura do pulso
    end else begin
        // Saída PWM
        pwm <= (contagem < largura_pwm);

        // Atualização do contador e da largura do pulso
        if (contagem == conf_periodo - 1) begin
            contagem <= 0;
            case (largura)
                3'b000: largura_pwm <= largura_000;
                3'b001: largura_pwm <= largura_001;
                3'b010: largura_pwm <= largura_010;
                3'b011: largura_pwm <= largura_011;
                3'b100: largura_pwm <= largura_100;
                3'b101: largura_pwm <= largura_101;
                3'b110: largura_pwm <= largura_110;
                3'b111: largura_pwm <= largura_111;
                default: largura_pwm <= largura_000; // Valor padrão
            endcase
        end else begin
            contagem <= contagem + 1;
        end
    end
end

endmodule
