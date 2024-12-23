module ripple_carry_adder_4bit (
    input  logic [3:0] A,    // 4-bit input A
    input  logic [3:0] B,    // 4-bit input B
    input  logic        Cin,  // Initial carry-in
    output logic [3:0] Sum,  // 4-bit sum output
    output logic        Cout  // Final carry-out
);
    logic [3:0] carry;  // Internal carry signals

    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : adder_gen
            if (i == 0) begin
                // First full adder
                full_adder FA (
                    .a(A[i]),
                    .b(B[i]),
                    .cin(Cin),
                    .sum(Sum[i]),
                    .cout(carry[i])
                );
            end else if (i == 3) begin
                // Last full adder
                full_adder FA (
                    .a(A[i]),
                    .b(B[i]),
                    .cin(carry[i-1]),
                    .sum(Sum[i]),
                    .cout(Cout)
                );
            end else begin
                // Intermediate full adders
                full_adder FA (
                    .a(A[i]),
                    .b(B[i]),
                    .cin(carry[i-1]),
                    .sum(Sum[i]),
                    .cout(carry[i])
                );
            end
        end
    endgenerate
endmodule
