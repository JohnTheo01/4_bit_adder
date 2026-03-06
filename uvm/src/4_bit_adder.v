// Basic 4-bit Adder/Subtractor using Ripple Carry Adder

module adder_subtractor_4bit (
    input  [3:0] A, B,
    input sub,  // 0: Add, 1: Subtract
    output logic [3:0] Result,
    output logic Cout
);
    wire [3:0] b_inv;
    wire c1, c2, c3;

    // XOR B with 'sub' to invert B when sub=1 (2's complement)
    xor u1 (b_inv[0], B[0], sub);
    xor u2 (b_inv[1], B[1], sub);
    xor u3 (b_inv[2], B[2], sub);
    xor u4 (b_inv[3], B[3], sub);

    // 4-bit Ripple Carry Adder
    // Result = A + B_inv + sub (sub acts as cin)

 
    /* verilator lint_on WIDTHEXPAND */

    // verilator lint_off WIDTHEXPAND
    assign {Cout, Result} = A + b_inv + sub;
    // verilator lint_on WIDTHEXPAND

    // initial $monitor("Time: %0t | A: %b | B: %b | Sub: %b | Result: %b | Cout: %b", $time, A, B, sub, Result, Cout);

endmodule
