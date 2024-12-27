module carry_lookahead_adder #(
    parameter N = 16
) (
    input  logic [N-1:0] A,    // Operand A
    input  logic [N-1:0] B,    // Operand B
    input  logic         Cin,  // Carry-in
    output logic [N-1:0] Sum,  // Sum output
    output logic         Cout  // Carry-out
);
    logic [N-1:0] G;           // Generate terms
    logic [N-1:0] P;           // Propagate terms
    logic [N:0]   C;           // Carry bits

    assign C[0] = Cin;

    // Generate and Propagate terms
    generate
        genvar i;
        for (i = 0; i < N; i++) begin
            assign G[i] = A[i] & B[i];
            assign P[i] = A[i] ^ B[i];
        end
    endgenerate

    // Carry Lookahead Logic
    generate
        for (i = 0; i < N; i++) begin
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    // Sum Calculation
    generate
        for (i = 0; i < N; i++) begin
            assign Sum[i] = P[i] ^ C[i];
        end
    endgenerate

    assign Cout = C[N];
endmodule
