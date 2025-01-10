module spi_slave #(
    parameter int DATA_WIDTH = 8  // Default data width
)(
    input  logic                   clk,        // System clock
    input  logic                   reset_n,    // Active-low reset
    input  logic                   MOSI,       // Master Out Slave In
    input  logic                   SCK,        // SPI clock from master
    input  logic                   start,      // Start signal for reception
    output logic [DATA_WIDTH-1:0]  data_out,   // Received data
    output logic                   done        // Reception complete indicator
);
    // Internal signals
    logic [DATA_WIDTH-1:0]         shift_reg;        // Shift register for assembling data
    logic [$clog2(DATA_WIDTH)-1:0] bit_cnt;          // Bit counter (adjusted size)
    logic                         SCK_r, SCK_rising_edge; // Registered SCK and rising edge detection
    logic                         receiving;         // Reception in progress flag

    // Detect rising edge of SCK
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            SCK_r <= 1'b0;
        end else begin
            SCK_r <= SCK;
        end
    end
    assign SCK_rising_edge = ~SCK_r & SCK;

    // SPI reception logic
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            shift_reg <= '0;
            bit_cnt   <= '0;
            data_out  <= '0;
            done      <= 1'b0;
            receiving <= 1'b0;
        end else begin
            if (start && !receiving) begin
                // Initiate reception
                receiving <= 1'b1;
                bit_cnt   <= DATA_WIDTH[$clog2(DATA_WIDTH)-1:0] - 1;
                done      <= 1'b0;
            end else if (receiving) begin
                if (SCK_rising_edge) begin
                    // Sample MOSI on rising edge of SCK
                    shift_reg[bit_cnt] <= MOSI;
                    if (bit_cnt == 0) begin
                        // Reception complete
                        data_out  <= shift_reg;
                        done      <= 1'b1;
                        receiving <= 1'b0;
                    end else begin
                        bit_cnt <= bit_cnt - 1;
                    end
                end
            end else begin
                done <= 1'b0;
            end
        end
    end
endmodule
