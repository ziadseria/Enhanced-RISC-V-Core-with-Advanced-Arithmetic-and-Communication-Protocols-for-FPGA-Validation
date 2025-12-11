`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/19/2025 11:04:17 PM
// Design Name: 
// Module Name: RISC_V_SoC_Top
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


`timescale 1ns / 1ps

module RISC_V_SoC_Top (
    input  wire        clk,
    input  wire        rst_n,

    // UART physical pins
    input  wire        rx,
    output wire        tx,

    // GPIO physical pins
    input  wire [7:0]  gpio_i,
    output wire [7:0]  gpio_o,
    output wire [7:0]  gpio_oe
);

    // APB interconnection wires between processor and APB peripherals
    wire [31:0] apb_addr;
    wire [31:0] apb_wdata;
    wire        apb_write;
    wire        apb_valid;
    wire [31:0] apb_rdata;
    wire        apb_ready;

    // -------------------------------
    // 1. Instantiate the RISC-V Pipeline Core
    // -------------------------------
    Pipeline_RISCV core (
        .clk(clk),
        .rst(rst_n),

        // APB interface to peripherals
        .apb_addr   (apb_addr),
        .apb_wdata  (apb_wdata),
        .apb_write  (apb_write),
        .apb_valid  (apb_valid),
        .apb_rdata  (apb_rdata),
        .apb_ready  (apb_ready)
    );

    // -------------------------------
    // 2. Instantiate the APB Peripherals Top
    // -------------------------------
    APB_Peripherals_Top apb_peripherals (
        .clk        (clk),
        .rst_n      (rst_n),

        // From Pipeline RISC-V
        .rv_addr    (apb_addr),
        .rv_wdata   (apb_wdata),
        .rv_write   (apb_write),
        .rv_valid   (apb_valid),
        .rv_rdata   (apb_rdata),
        .rv_ready   (apb_ready),
        .rv_done    (), // optional; not used in this case

        // UART physical interface
        .rx         (rx),
        .tx         (tx),

        // GPIO pins
        .gpio_i     (gpio_i),
        .gpio_o     (gpio_o),
        .gpio_oe    (gpio_oe)
    );

endmodule
