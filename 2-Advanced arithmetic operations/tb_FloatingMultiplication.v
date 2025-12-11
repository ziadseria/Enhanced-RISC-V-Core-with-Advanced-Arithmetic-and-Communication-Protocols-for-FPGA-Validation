`timescale 1ns/1ps

module tb_FloatingMultiplication();
    reg clk;
    reg rst;
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] result;

    // Instantiate DUT
    FloatingMultiplication dut (
        .clk(clk),
        .rst(rst),
        .A(A),
        .B(B),
        .result(result)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        A = 0;
        B = 0;

        // Reset
        @(negedge clk);
        rst = 0;

        // Test case 1: 2.0 * 3.0
        @(negedge clk);
        A = 32'h40000000;  // 2.0
        B = 32'h40400000;  // 3.0

        // Test case 2: -1.5 * 4.0
        @(negedge clk);
        A = 32'hBFC00000;  // -1.5
        B = 32'h40800000;  // 4.0

        // Test case 3: 0.5 * 0.5
        @(negedge clk);
        A = 32'h3F000000;  // 0.5
        B = 32'h3F000000;  // 0.5

        // Test case 4: 0 * 1.0
        @(negedge clk);
        A = 32'h00000000;  // 0
        B = 32'h3F800000;  // 1.0

        // Finish
        @(negedge clk);
        $finish;
    end

    

endmodule
