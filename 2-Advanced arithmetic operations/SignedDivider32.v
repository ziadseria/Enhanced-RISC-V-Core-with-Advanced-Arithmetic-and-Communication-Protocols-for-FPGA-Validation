`timescale 1ns / 1ps
//Mansoura University Digital IC team

// 32-bit Signed Restoring Divider
module SignedDivider32 (
    input  [31:0] dividend,
    input  [31:0] divisor,
    output reg [31:0] quotient,
    output reg [31:0] remainder
);
    reg [31:0] A, Q, M;
    reg [31:0] A_before;
    reg [63:0] AQ;
    reg sign_a, sign_b, sign_q, sign_r;
    integer i;

    always @(*) begin
        // Input signs
        sign_a = dividend[31];
        sign_b = divisor[31];
        sign_q = sign_a ^ sign_b;
        sign_r = sign_a;

        // Handle division by zero
        if (divisor == 32'd0) begin
            quotient  = 32'hFFFFFFFF;  // indicate error
            remainder = dividend;
        end else begin
            // Get absolute values
            Q = sign_a ? (~dividend + 1) : dividend;
            M = sign_b ? (~divisor + 1)  : divisor;
            A = 32'd0;

            for (i = 0; i < 32; i = i + 1) begin
                AQ = {A, Q} << 1;
                A  = AQ[63:32];
                Q  = AQ[31:0];

                A_before = A;
                A = A - M;

                if (A[31]) begin
                    A = A_before;
                    Q[0] = 1'b0;
                end else begin
                    Q[0] = 1'b1;
                end
            end

            // Apply sign to quotient
            quotient = sign_q ? (~Q + 1) : Q;
            // Apply sign to remainder
            remainder = sign_r ? (~A + 1) : A;
        end
    end
endmodule