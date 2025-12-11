`timescale 1ns / 1ps
module FloatingAddition #(parameter XLEN=32)
(
    input clk,
    input rst,
    input [XLEN-1:0] A,
    input [XLEN-1:0] B,
    output reg [XLEN-1:0] result
);

reg [31:0] A_swap, B_swap;  
wire [7:0] A_Exponent = A_swap[30:23];
wire [7:0] B_Exponent = B_swap[30:23];
wire A_sign = A_swap[31];
wire B_sign = B_swap[31];

//  denormalized
wire [23:0] A_Mantissa = (A_swap[30:0] == 0) ? 24'b0 : (A_Exponent == 8'b0 ? {1'b0, A_swap[22:0]} : {1'b1, A_swap[22:0]});
wire [23:0] B_Mantissa = (B_swap[30:0] == 0) ? 24'b0 : (B_Exponent == 8'b0 ? {1'b0, B_swap[22:0]} : {1'b1, B_swap[22:0]});

reg [23:0] Temp_Mantissa, B_shifted_mantissa;
reg [22:0] Mantissa;
reg [7:0] Exponent;
reg Sign;
reg [7:0] diff_Exponent;
reg carry;
wire comp;
integer i;


FloatingCompare comp_abs(.A({1'b0, A[30:0]}), .B({1'b0, B[30:0]}), .result(comp));

reg [XLEN-1:0] result_comb;


always @* begin
    A_swap = comp ? A : B;
    B_swap = comp ? B : A;

    diff_Exponent = A_Exponent - B_Exponent;
    B_shifted_mantissa = (B_Mantissa >> diff_Exponent);

    {carry, Temp_Mantissa} = (A_sign ~^ B_sign) ? (A_Mantissa + B_shifted_mantissa) : (A_Mantissa - B_shifted_mantissa);
    Exponent = A_Exponent;

    if (carry) begin
        Temp_Mantissa = Temp_Mantissa >> 1;
        Exponent = (Exponent < 8'hff) ? Exponent + 1 : 8'hff;
    end 
    else if (Temp_Mantissa == 0) begin
        Temp_Mantissa = 0;
        Exponent = 0;
    end 
    else begin
        for (i = 0; Temp_Mantissa[23] !== 1'b1 && Exponent > 0 && i < 24; i = i + 1) begin
            Temp_Mantissa = Temp_Mantissa << 1;
            Exponent = Exponent - 1;
        end
    end

    Sign = A_sign;
    Mantissa = Temp_Mantissa[22:0];
    result_comb = {Sign, Exponent, Mantissa};
end


always @(posedge clk or posedge rst) begin
    if (rst) begin
        result <= 0;
    end else begin
        result <= result_comb;
    end
end

endmodule

