`timescale 1ns / 1ps
module locker_controller #(
    parameter [15:0] PASSWORD = 16'h1234
)(
    input  wire       clk,
    input  wire       rst,
    input  wire [3:0] key,
    input  wire       key_valid,
    output reg  [15:0] entered_digits,
    output reg  [2:0] digit_count,
    output reg        unlocked,
    output reg        error
);
    // Keypad codes E='*' (clear), F='#' (submit).
    always @(posedge clk) begin
        if (rst) begin
            entered_digits <= 16'hFFFF;
            digit_count <= 0;
            unlocked <= 1'b0;
            error <= 1'b0;
        end else if (key_valid) begin
            if (key == 4'hE) begin
                entered_digits <= 16'hFFFF;
                digit_count <= 0;
                unlocked <= 1'b0;
                error <= 1'b0;
            end else if (key == 4'hF) begin
                if (digit_count == 4) begin
                    if (entered_digits == PASSWORD) begin
                        unlocked <= 1'b1;
                        error <= 1'b0;
                    end else begin
                        unlocked <= 1'b0;
                        error <= 1'b1;
                    end
                end else begin
                    error <= 1'b1;
                end
                entered_digits <= 16'hFFFF;
                digit_count <= 0;
            end else if (key <= 4'd9 && digit_count < 4 && !unlocked) begin
                case (digit_count)
                    0: entered_digits[15:12] <= key;
                    1: entered_digits[11:8]  <= key;
                    2: entered_digits[7:4]   <= key;
                    3: entered_digits[3:0]   <= key;
                endcase
                digit_count <= digit_count + 1'b1;
                error <= 1'b0;
            end
        end
    end
endmodule
