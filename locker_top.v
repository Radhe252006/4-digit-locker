`timescale 1ns / 1ps
module locker_top #(
    parameter integer CLK_HZ = 100_000_000,
    parameter [15:0] PASSWORD = 16'h1234
)(
    input  wire       clk,
    input  wire       reset,       // active-high reset
    input  wire [3:0] keypad_row_n,
    output wire [3:0] keypad_col_n,
    output wire [7:0] seg_n,
    output wire [3:0] an_n,
    output wire       unlock_led,
    output wire       error_led
);
    wire [3:0] key;
    wire key_valid;
    wire [15:0] entered_digits;
    wire [2:0] digit_count;
    wire unlocked, error;

    keypad_scanner #(.CLK_HZ(CLK_HZ)) u_keypad (
        .clk(clk), .rst(reset),
        .col_n(keypad_col_n), .row_n(keypad_row_n),
        .key(key), .key_valid(key_valid)
    );

    locker_controller #(.PASSWORD(PASSWORD)) u_controller (
        .clk(clk), .rst(reset), .key(key), .key_valid(key_valid),
        .entered_digits(entered_digits), .digit_count(digit_count),
        .unlocked(unlocked), .error(error)
    );

    sevenseg_mux #(.CLK_HZ(CLK_HZ)) u_display (
        .clk(clk), .rst(reset), .digits(entered_digits),
        .seg_n(seg_n), .an_n(an_n)
    );

    assign unlock_led = unlocked;
    assign error_led = error;
endmodule
