// 1. Parameterized N-Bit Adder-Subtractor
module adder_subtractor #(parameter N = 8) (
    input logic [N-1:0] A, B,        // N-bit inputs
    input logic Sub,                  // Subtract control signal
    output logic [N-1:0] Result       // N-bit result
);
    logic [N-1:0] B_mux;             // Inverted B for subtraction
    logic Carry;

    assign B_mux = Sub ? ~B : B;     // Invert B when Sub = 1
    assign {Carry, Result} = A + B_mux + Sub; // Perform addition or subtraction
endmodule


// 2. 4-Bit Register with Synchronous Reset and Enable
module register_4bit (
    input logic clk, reset, enable,  // Clock, reset, and enable signals
    input logic [3:0] D,             // 4-bit data input
    output logic [3:0] Q             // 4-bit data output
);
    always_ff @(posedge clk) begin
        if (reset)
            Q <= 4'b0000;            // Reset Q to 0
        else if (enable)
            Q <= D;                 // Update Q with D if enable is active
    end
endmodule


// 3. 3-Bit Binary Counter
module counter_3bit (
    input logic clk, reset, enable,  // Clock, reset, and enable signals
    output logic [2:0] count         // 3-bit counter output
);
    always_ff @(posedge clk) begin
        if (reset)
            count <= 3'b000;         // Reset count to 0
        else if (enable)
            count <= count + 1;     // Increment count if enable is active
    end
endmodule


// 4. 4x4 Array Multiplier
module array_multiplier_4x4 (
    input logic [3:0] A, B,          // 4-bit inputs A and B
    output logic [7:0] Product       // 8-bit product output
);
    logic [3:0] partial_products[3:0]; // Partial products

    // Generate partial products
    genvar i, j;
    generate
        for (i = 0; i < 4; i++) begin
            for (j = 0; j < 4; j++) begin
                assign partial_products[i][j] = A[j] & B[i];
            end
        end
    endgenerate

    // Sum of partial products
    logic [7:0] sum1, sum2, sum3, temp1, temp2, temp3;

    assign sum1 = {4'b0000, partial_products[0]};             // Align partial product 0
    assign temp1 = {3'b000, partial_products[1], 1'b0};       // Shift partial product 1
    assign sum2 = sum1 + temp1;

    assign temp2 = {2'b00, partial_products[2], 2'b00}; 
