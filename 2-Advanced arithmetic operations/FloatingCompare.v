`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/25/2025 07:39:26 AM
// Design Name: 
// Module Name: FloatingCompare
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




`ifndef _floating_compare
`define _floating_compare

module FloatingCompare (
    input [31:0] A,
    input [31:0] B,
    output reg result
);

    always @(*) begin
        if (A == B) begin
            result = 1'b1;  // A == B ? result = 1
        end else if (A[31] != B[31]) begin
            result = ~A[31];  // A ???? ? result = 1
        end else if (A[30:23] != B[30:23]) begin
            result = (A[30:23] > B[30:23]) ? 1'b1 : 1'b0;
            if (A[31]) result = ~result;  // ?? ???? ????
        end else begin
            if (A[22:0] == B[22:0])
                result = 1'b1;
            else begin
                result = (A[22:0] > B[22:0]) ? 1'b1 : 1'b0;
                if (A[31]) result = ~result;
            end
        end
    end

endmodule

`endif //_floating_compare
