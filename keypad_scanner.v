`timescale 1ns / 1ps
// 4x4 matrix keypad scanner.
// Rows and columns are active-low. key_valid pulses once per press;
// a key must be released before another key event is generated.
module keypad_scanner #(
    parameter integer CLK_HZ = 100_000_000,
    parameter integer SCAN_HZ = 1000
)(
    input  wire       clk,
    input  wire       rst,
    output reg  [3:0] col_n,
    input  wire [3:0] row_n,
    output reg  [3:0] key,
    output reg        key_valid
);
    localparam integer DIVISOR = (CLK_HZ / (SCAN_HZ * 4) < 1) ? 1 :
                                  (CLK_HZ / (SCAN_HZ * 4));
    localparam integer CW = (DIVISOR <= 1) ? 1 : $clog2(DIVISOR);

    reg [CW-1:0] div_count;
    reg [1:0] col_index;
    reg pressed;

    wire any_row_low = (row_n != 4'b1111);

    // Key map:
    // 1 2 3 A
    // 4 5 6 B
    // 7 8 9 C
    // * 0 # D
    function [3:0] decode_key;
        input [1:0] r;
        input [1:0] c;
        begin
            case ({r,c})
                4'b0000: decode_key=4'h1;
                4'b0001: decode_key=4'h2;
                4'b0010: decode_key=4'h3;
                4'b0011: decode_key=4'hA;
                4'b0100: decode_key=4'h4;
                4'b0101: decode_key=4'h5;
                4'b0110: decode_key=4'h6;
                4'b0111: decode_key=4'hB;
                4'b1000: decode_key=4'h7;
                4'b1001: decode_key=4'h8;
                4'b1010: decode_key=4'h9;
                4'b1011: decode_key=4'hC;
                4'b1100: decode_key=4'hE; // '*'
                4'b1101: decode_key=4'h0;
                4'b1110: decode_key=4'hF; // '#'
                4'b1111: decode_key=4'hD;
                default: decode_key=4'h0;
            endcase
        end
    endfunction

    reg [1:0] row_index;

    always @(*) begin
        case (row_n)
            4'b1110: row_index = 2'd0;
            4'b1101: row_index = 2'd1;
            4'b1011: row_index = 2'd2;
            4'b0111: row_index = 2'd3;
            default: row_index = 2'd0;
        endcase
    end

    always @(posedge clk) begin
        if (rst) begin
            div_count <= 0;
            col_index <= 0;
            col_n <= 4'b1110;
            key <= 0;
            key_valid <= 0;
            pressed <= 0;
        end else begin
            key_valid <= 1'b0;
            if (div_count == DIVISOR-1) begin
                div_count <= 0;
                // Sample the column that has been active during this scan interval.
                if (any_row_low && !pressed) begin
                    key <= decode_key(row_index, col_index);
                    key_valid <= 1'b1;
                    pressed <= 1'b1;
                end else if (!any_row_low) begin
                    pressed <= 1'b0;
                end

                // Drive the next column for the next scan interval.
                col_index <= col_index + 1'b1;
                case (col_index + 1'b1)
                    2'd0: col_n <= 4'b1110;
                    2'd1: col_n <= 4'b1101;
                    2'd2: col_n <= 4'b1011;
                    2'd3: col_n <= 4'b0111;
                endcase
            end else begin
                div_count <= div_count + 1'b1;
            end
        end
    end
endmodule
