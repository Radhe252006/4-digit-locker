`timescale 1ns / 1ps
module tb_locker_controller;
    reg clk = 0;
    reg rst = 1;
    reg [3:0] key = 0;
    reg key_valid = 0;
    wire [15:0] entered_digits;
    wire [2:0] digit_count;
    wire unlocked, error;

    locker_controller #(.PASSWORD(16'h1234)) dut (
        .clk(clk), .rst(rst), .key(key), .key_valid(key_valid),
        .entered_digits(entered_digits), .digit_count(digit_count),
        .unlocked(unlocked), .error(error)
    );

    always #5 clk = ~clk;

    task press_key(input [3:0] value);
        begin
            @(negedge clk); key=value; key_valid=1;
            @(negedge clk); key_valid=0;
            repeat (2) @(negedge clk);
        end
    endtask

    initial begin
        $dumpfile("locker.vcd");
        $dumpvars(0, tb_locker_controller);
        repeat (3) @(negedge clk);
        rst=0;

        // Correct password 1234, then submit with '#'.
        press_key(4'd1);
        press_key(4'd2);
        press_key(4'd3);
        press_key(4'd4);
        press_key(4'hF);
        if (!unlocked) $fatal(1, "Correct password did not unlock");
        $display("PASS: correct password unlocks");

        // '*' clears and locks again. Wrong password should set error.
        press_key(4'hE);
        press_key(4'd9);
        press_key(4'd9);
        press_key(4'd9);
        press_key(4'd9);
        press_key(4'hF);
        if (!error || unlocked) $fatal(1, "Wrong password handling failed");
        $display("PASS: wrong password sets error");

        $display("All locker controller tests passed.");
        $finish;
    end
endmodule
