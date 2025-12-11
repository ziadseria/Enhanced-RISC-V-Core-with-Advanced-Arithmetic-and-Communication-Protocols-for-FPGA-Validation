`timescale 1ns / 1ps
//Masoura Digital IC Team
module FloatingMultiplication #(parameter XLEN = 32)
(
    input clk,
    input rst,
    input [XLEN-1:0] A,
    input [XLEN-1:0] B,
    output reg [XLEN-1:0] result
);
    wire sign_A = A[31];
    wire sign_B = B[31];
    wire [7:0] exp_A = A[30:23];
    wire [7:0] exp_B = B[30:23];
    wire [22:0] frac_A = A[22:0];
    wire [22:0] frac_B = B[22:0];

    wire [23:0] mant_A = (exp_A == 0) ? {1'b0, frac_A} : {1'b1, frac_A};
    wire [23:0] mant_B = (exp_B == 0) ? {1'b0, frac_B} : {1'b1, frac_B};

    wire sign_result = sign_A ^ sign_B;
    wire [47:0] mant_product = mant_A * mant_B;
    wire [9:0] exp_sum = exp_A + exp_B - 8'd127;

    reg [22:0] final_frac;
    reg [7:0] final_exp;
    reg [31:0] result_comb;

    always @(*) begin
        
        final_frac = 0;
        final_exp = 0;
        result_comb = 0;

        if (A == 0 || B == 0) begin
            result_comb = 0;
        end else begin
            if (mant_product[47]) begin
                final_frac = mant_product[46:24];
                final_exp = exp_sum + 1;
            end else begin
                final_frac = mant_product[45:23];
                final_exp = exp_sum;
            end

            if (final_exp >= 8'hFF) begin
                final_exp = 8'hFF;
                final_frac = 0;
            end else if (final_exp <= 0) begin
                final_exp = 0;
                final_frac = 0;
            end

            result_comb = {sign_result, final_exp, final_frac};
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            result <= 32'b0;
        else
            result <= result_comb;
    end

endmodule
