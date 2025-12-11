`timescale 1ns / 1ps
//count from 0 to final value to generate 16 tick in one data period

// final value = (clock frequency /(16 * baud rate)) - 1
//example

// clock frequenct "f" = 100MHZ
// baud rate "b" = 9600 bits/second
//final value = 650
//1010001010

module BaudRate_Generator #(parameter BITS = 10)(
    input clk,
    input reset_n,
    input enable,
    input[BITS - 1 : 0] FINAL_VALUE,
    output done
    );
    
    reg [BITS - 1: 0] Q_reg,Q_next;
  
    always @(posedge clk, negedge reset_n) begin
    if(~reset_n)
      Q_reg <= 'b0;
    else if(enable)
      Q_reg <= Q_next;
    else
      Q_reg <= Q_reg;
    end
  
    assign done = (Q_reg == FINAL_VALUE);
  
    always @(*)
      Q_next = done? 'b0 : Q_reg+1;
endmodule
