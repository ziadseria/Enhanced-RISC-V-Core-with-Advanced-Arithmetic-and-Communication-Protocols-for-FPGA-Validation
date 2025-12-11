`timescale 1ns / 1ps
//Mansoura Digital IC Team
// 32-bit Signed Shift-and-Add Multiplier
module SignedMultiplier32 (
    input  [31:0] a,       // 32-bit signed multiplicand
    input  [31:0] b,       // 32-bit signed multiplier
    output [63:0] product  // 64-bit product output
);
    // Internal registers for computation
    reg [63:0] result;
    reg [63:0] a_ext, b_ext;
    reg [63:0] a_mag, b_mag; 
    reg        sign_a, sign_b, sign_result;
    integer    i;
    
    always @(*) begin
        // Determine the sign of inputs
        sign_a = a[31];
        sign_b = b[31];
        sign_result = sign_a ^ sign_b;  // result sign is XOR of input signs (true if result should be negative)
        
        // Extend operands to 64-bit and take absolute values (magnitude)
        a_ext = {{32{a[31]}}, a};            // sign-extend 'a' to 64 bits
        b_ext = {{32{b[31]}}, b};            // sign-extend 'b' to 64 bits
        if (sign_a) 
            a_mag = (~a_ext + 1);           // two's complement if negative
        else 
            a_mag = a_ext;
        if (sign_b) 
            b_mag = (~b_ext + 1);
        else 
            b_mag = b_ext;
        
        // Initialize result accumulator to 0
        result = 64'd0;
        // Perform shift-and-add multiplication
        for (i = 0; i < 32; i = i + 1) begin
            if (b_mag[i] == 1'b1) begin
                // If the i-th bit of multiplier's magnitude is 1, add (multiplicand << i) to the result
                result = result + (a_mag << i);
            end
        end
        
        // Apply the sign to the result (two's complement if the expected product is negative)
        if (sign_result) begin
            result = ~result + 1'b1;
        end
    end
    
    assign product = result;
endmodule