module ripple_carry_adder #(
    parameter WIDTH = 4 // Parameter to set the width of the adder
)(
    input  logic [WIDTH-1:0] A,    // N-bit input A
    input  logic [WIDTH-1:0] B,    // N-bit input B
    input  logic             Cin,  // Initial carry-in
    output logic [WIDTH-1:0] Sum,  // N-bit sum output
    output logic             Cout  // Final carry-out
);
    logic [WIDTH-1:0] carry;  // Internal carry signals

    genvar i;
    generate
        for (i = 0; i < WIDTH; i = i + 1) begin : adder_gen
            if (i == 0) begin
                // First full adder
                full_adder FA (
                    .a(A[i]),
                    .b(B[i]),
                    .cin(Cin),
                    .sum(Sum[i]),
                    .cout(carry[i])
                );
            end else if (i == WIDTH-1) begin
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
//sometext