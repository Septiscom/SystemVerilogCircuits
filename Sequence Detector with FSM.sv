module sequence_detector (
    input  logic clk, rst, in,    // Clock, reset, and single-bit input
    output logic detected           // Output high when sequence is detected
);
    // State encoding
    typedef enum logic [2:0] {
        S0, // Initial state
        S1, // Detected '1'
        S2, // Detected '10'
        S3, // Detected '101'
        S4  // Detected '1011'
    } state_t;

    state_t current_state, next_state;

    // State transition
    always_ff @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Next state logic
    always_comb begin
        case (current_state)
            S0: next_state = (in) ? S1 : S0;
            S1: next_state = (in) ? S1 : S2;
            S2: next_state = (in) ? S3 : S0;
            S3: next_state = (in) ? S4 : S2;
            S4: next_state = (in) ? S1 : S2;
            default: next_state = S0;
        endcase
    end

    // Output logic
    always_comb begin
        detected = (current_state == S4);
    end
endmodule
//sometext