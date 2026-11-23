`timescale 1ns / 1ps
// Common-anode style output: active-low segments and active-low anodes.
// Segment order is {a,b,c,d,e,f,g,dp}.
module sevenseg_mux #(
    parameter integer CLK_HZ = 100_000_000,
    parameter integer REFRESH_HZ = 1000
)(
    input  wire        clk,
    input  wire        rst,
    input  wire [15:0] digits,
    output reg  [7:0]  seg_n,
    output reg  [3:0]  an_n
);
    localparam integer DIVISOR = (CLK_HZ / (REFRESH_HZ * 4) < 1) ? 1 :
                                  (CLK_HZ / (REFRESH_HZ * 4));
    localparam integer CW = (DIVISOR <= 1) ? 1 : $clog2(DIVISOR);
    reg [CW-1:0] count;
    reg [1:0] sel;
    reg [3:0] nibble;

    always @(*) begin
        case (sel)
            2'd0: begin an_n=4'b1110; nibble=digits[3:0]; end
            2'd1: begin an_n=4'b1101; nibble=digits[7:4]; end
            2'd2: begin an_n=4'b1011; nibble=digits[11:8]; end
            default: begin an_n=4'b0111; nibble=digits[15:12]; end
        endcase

        case (nibble)
            4'h0: seg_n=8'b00000011;
            4'h1: seg_n=8'b10011111;
            4'h2: seg_n=8'b00100101;
            4'h3: seg_n=8'b00001101;
            4'h4: seg_n=8'b10011001;
            4'h5: seg_n=8'b01001001;
            4'h6: seg_n=8'b01000001;
            4'h7: seg_n=8'b00011111;
            4'h8: seg_n=8'b00000001;
            4'h9: seg_n=8'b00001001;
            default: seg_n=8'b11111111; // blank
        endcase
    end

    always @(posedge clk) begin
        if (rst) begin
            count <= 0;
            sel <= 0;
        end else if (count == DIVISOR-1) begin
            count <= 0;
            sel <= sel + 1'b1;
        end else begin
            count <= count + 1'b1;
        end
    end
endmodule
