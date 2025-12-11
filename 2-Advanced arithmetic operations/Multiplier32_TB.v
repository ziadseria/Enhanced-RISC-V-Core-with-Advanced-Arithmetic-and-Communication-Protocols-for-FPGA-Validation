`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2025 01:01:59 PM
// Design Name: 
// Module Name: Multiplier32_TB
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



module Multiplier32_TB;
    reg  [31:0] a, b;
    wire [63:0] product;
    
    // Instantiate the multiplier module
    SignedMultiplier32 uut (
        .a(a),
        .b(b),
        .product(product)
    );
    
    initial begin
        $display("32-bit Signed Shift-and-Add Multiplier Testbench");
        // Test case 1:  0 * 0
        a = 32'd0; 
        b = 32'd0;
        #1;
        $display("%0d * %0d = %0d (hex %h)", a, b, product, product);
        
        // Test case 2:  1 * -1 (positive * negative)
        a = 32'd1;
        b = -32'd1;
        #1;
        $display("%0d * %0d = %0d (hex %h)", a, b, product, product);
        
        // Test case 3:  -1 * -1 (negative * negative -> positive result)
        a = -32'd1;
        b = -32'd1;
        #1;
        $display("%0d * %0d = %0d (hex %h)", a, b, product, product);
        
        // Test case 4:  12345 * -6789 (random positive * negative)
        a = 32'd12345;
        b = -32'd6789;
        #1;
        $display("%0d * %0d = %0d (hex %h)", a, b, product, product);
        
        // Test case 5:  MaxInt * 1 (2147483647 * 1)
        a = 32'd2147483647;       //  2^31 - 1 (max 32-bit signed)
        b = 32'd1;
        #1;
        $display("%0d * %0d = %0d (hex %h)", a, b, product, product);
        
        // Test case 6:  MinInt * 1 (-2147483648 * 1)
        a = -32'd2147483648;      // -2^31 (min 32-bit signed)
        b = 32'd1;
        #1;
        $display("%0d * %0d = %0d (hex %h)", a, b, product, product);
        
        // Test case 7:  MaxInt * MaxInt (to test overflow handling in 64-bit result)
        a = 32'd2147483647; 
        b = 32'd2147483647;
        #1;
        $display("%0d * %0d = %0d (hex %h)", a, b, product, product);
        
        $stop;  // Stop simulation
    end
endmodule