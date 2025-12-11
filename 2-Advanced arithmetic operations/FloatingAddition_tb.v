`timescale 1ns/1ps

module tb_FloatingAddition();

    reg clk;
    reg rst;
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] result;

    // Instantiate DUT
    FloatingAddition dut (
        .clk(clk),
        .rst(rst),
        .A(A),
        .B(B),
        .result(result)
    );

    // Clock generation
    always #5 clk = ~clk;  // Clock period = 10ns

    initial begin
        clk = 0;
        rst = 1;
        A = 0;
        B = 0;

        // Reset phase
        @(posedge clk);
        rst = 0;
        

        // Test case 1
        @(negedge clk);
        A = 32'h3F800000;  // 1.0
        B = 32'h40000000;  // 2.0

       

        // Test case 2
        @(negedge clk);
        A = 32'hBFC00000;  // -1.5
        B = 32'h40400000;  // 3.0

       

        // Test case 3
        @(negedge clk);
        A = 32'h00000000;  // 0.0
        B = 32'h00000000;  // 0.0

       

        // Test case 4
        @(negedge clk);
        A = 32'hC0200000;  // -2.5
        B = 32'h40200000;  // 2.5

      

        $finish;
    end
    

endmodule
