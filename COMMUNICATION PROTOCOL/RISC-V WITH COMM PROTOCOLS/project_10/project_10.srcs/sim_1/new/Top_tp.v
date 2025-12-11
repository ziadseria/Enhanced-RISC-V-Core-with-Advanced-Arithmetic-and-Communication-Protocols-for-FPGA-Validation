
`timescale 1ns / 1ps

module Top_tp();
    


    // Clock and reset
    reg clk;
    reg rst_n;

    // UART
    reg  rx;
    wire tx;

    // GPIO
    reg  [7:0] gpio_i;
    wire [7:0] gpio_o;
    wire [7:0] gpio_oe;

    // Instantiate the top-level SoC
    RISC_V_SoC_Top dut (
        .clk      (clk),
        .rst_n    (rst_n),
        .rx       (rx),
        .tx       (tx),
        .gpio_i   (gpio_i),
        .gpio_o   (gpio_o),
        .gpio_oe  (gpio_oe)
    );

    // Generate clock
    initial clk = 0;
    always #5 clk = ~clk; // 100 MHz clock (10ns period)

    // Test procedure
    initial begin
        // Initialize
        $display("Simulation Start");
        rx      = 1'b1; // Idle line
        gpio_i  = 8'b10101010; // example input values
        rst_n   = 0;

        // Apply reset
        #20;
        rst_n = 1;

        // Wait for some cycles to allow RISC-V boot and APB transactions
        #1000;

        // Simulation monitor
        $display("GPIO Output = %b", gpio_o);
        $display("GPIO Output Enable = %b", gpio_oe);

        // End simulation
        #100;
        $finish;
    end

endmodule

