
module mux_8x1_n #(
    parameter BITS = 4
) (
    input  [BITS-1:0] D7,
    input  [BITS-1:0] D6,
    input  [BITS-1:0] D5,
    input  [BITS-1:0] D4,
    input  [BITS-1:0] D3,
    input  [BITS-1:0] D2,
    input  [BITS-1:0] D1,
    input  [BITS-1:0] D0,
    input  [2:0]      SEL,
    output [BITS-1:0] MUX_OUT
);

    assign MUX_OUT = (SEL == 3'b111) ? D7 :
                     (SEL == 3'b110) ? D6 :
                     (SEL == 3'b101) ? D5 :
                     (SEL == 3'b100) ? D4 :
                     (SEL == 3'b011) ? D3 :
                     (SEL == 3'b010) ? D2 :
                     (SEL == 3'b001) ? D1 :
                     (SEL == 3'b000) ? D0 :
                    
                     {BITS{1'b1}}; // default 

endmodule

