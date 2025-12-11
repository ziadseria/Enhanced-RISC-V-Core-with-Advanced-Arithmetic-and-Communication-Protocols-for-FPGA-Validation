`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2025 01:12:12 PM
// Design Name: 
// Module Name: Divider32_TB
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



module Divider32_TB;
    reg  [31:0] dividend, divisor;
    wire [31:0] quotient, remainder;

    SignedDivider32 uut (
        .dividend(dividend),
        .divisor(divisor),
        .quotient(quotient),
        .remainder(remainder)
    );

    initial begin
        $display("DIVIDEND / DIVISOR = QUOTIENT | REMAINDER");
        
        dividend = 32'd10; divisor = 32'd3; #1;
        $display("%0d / %0d = %0d | %0d", dividend, divisor, quotient, remainder);

        dividend = -32'd10; divisor = 32'd3; #1;
        $display("%0d / %0d = %0d | %0d", dividend, divisor, quotient, remainder);

        dividend = 32'd10; divisor = -32'd3; #1;
        $display("%0d / %0d = %0d | %0d", dividend, divisor, quotient, remainder);

        dividend = -32'd10; divisor = -32'd3; #1;
        $display("%0d / %0d = %0d | %0d", dividend, divisor, quotient, remainder);

        dividend = 32'd0; divisor = 32'd3; #1;
        $display("%0d / %0d = %0d | %0d", dividend, divisor, quotient, remainder);

        dividend = 32'd7; divisor = 32'd7; #1;
        $display("%0d / %0d = %0d | %0d", dividend, divisor, quotient, remainder);

        dividend = 32'd7; divisor = 32'd0; #1;
        $display("%0d / %0d = %0d | %0d", dividend, divisor, quotient, remainder);

        $finish;
    end
endmodule