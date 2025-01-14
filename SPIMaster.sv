module spi_master #(
    parameter int DATA_WIDTH = 8  // Default data width
)(
    input  logic                   clk,        // System clock
    input  logic                   reset_n,    // Active-low reset
    input  logic [DATA_WIDTH-1:0]  data_in,    // Data to be transmitted
    input  logic                   start,      // Start signal for transmission
    output logic                   MOSI,       // Master Out Slave In
    output logic                   SCK,        // SPI clock
    output logic                   done        // Transmission complete indicator
);
    // Local parameters
    localparam int CLOCK_DIV = 4;   // Clock divider for SCK generation

    // Internal signals
    logic [$clog2(CLOCK_DIV)-1:0] clk_div;   // Clock divider counter
    logic [$clog2(DATA_WIDTH)-1:0] bit_cnt;  // Bit counter (adjusted size)
    logic [DATA_WIDTH-1:0]        shift_reg; // Shift register for data
    logic                         busy;      // Busy flag

    // Clock divider for generating SCK
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            clk_div <= '0;
            SCK     <= 1'b0;
        end else if (busy) begin
            if (clk_div == (CLOCK_DIV[$clog2(CLOCK_DIV)-1:0] - 1)) begin
                clk_div <= '0;
                SCK     <= ~SCK;
            end else begin
                clk_div <= clk_div + 1;
            end
        end else begin
            clk_div <= '0;
            SCK     <= 1'b0;
        end
    end

    // State machine for SPI transmission
    always_ff @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
            busy      <= 1'b0;
            done      <= 1'b0;
            bit_cnt   <= '0;
            shift_reg <= '0;
            MOSI      <= 1'b0;
        end else begin
            if (start && !busy) begin
                // Initiate transmission
                busy      <= 1'b1;
                done      <= 1'b0;
                bit_cnt   <= DATA_WIDTH[$clog2(DATA_WIDTH)-1:0] - 1;
                shift_reg <= data_in;
                MOSI      <= data_in[DATA_WIDTH - 1];
            end else if (busy) begin
                if (clk_div == (CLOCK_DIV[$clog2(CLOCK_DIV)-1:0] - 1) && SCK == 1'b0) begin
                    // Shift data on falling edge of SCK
                    shift_reg <= {shift_reg[DATA_WIDTH-2:0], 1'b0};
                    bit_cnt   <= bit_cnt - 1;
                    MOSI      <= shift_reg[DATA_WIDTH-2];
                    if (bit_cnt == 0) begin
                        // Transmission complete
                        busy <= 1'b0;
                        done <= 1'b1;
                    end
                end
            end else begin
                done <= 1'b0;
            end
        end
    end
endmodule
//sometext