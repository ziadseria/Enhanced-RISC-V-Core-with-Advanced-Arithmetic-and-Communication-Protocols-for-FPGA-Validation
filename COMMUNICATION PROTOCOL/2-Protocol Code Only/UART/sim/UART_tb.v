`timescale 1ns / 1ps

module UART_tb();

  // Parameters
  parameter DBIT = 8;
  parameter SB_TICK = 16;
  parameter FINAL_VAL = 10'd16; // Slow down for simulation

  // DUT signals
  reg clk = 0;
  reg reset_n = 0;

  // TX signals
  reg [DBIT-1:0] w_data;
  reg wr_uart;
  wire tx_full;
  wire tx;

  // RX signals
  wire [DBIT-1:0] r_data;
  reg rd_uart;
  wire rx_empty;
  wire rx = tx;  // Loopback: Connect TX output to RX input

  // Timer config
  wire [10:0] TIMER_FINAL_VALUE = FINAL_VAL;

  // Instantiate DUT
  UART #(.DBIT(DBIT), .SB_TICK(SB_TICK)) uart_dut (
    .clk(clk),
    .reset_n(reset_n),
    .w_data(w_data),
    .wr_uart(wr_uart),
    .tx_full(tx_full),
    .tx(tx),
    .r_data(r_data),
    .rd_uart(rd_uart),
    .rx_empty(rx_empty),
    .rx(rx),
    .TIMER_FINAL_VALUE(TIMER_FINAL_VALUE)
  );

  // Clock generation
  always #5 clk = ~clk;  // 100MHz

  initial begin
    $dumpfile("uart_tb.vcd");
    $dumpvars(0, UART_tb);

    // Initialization
    wr_uart = 0;
    rd_uart = 0;
    w_data = 8'h00;

    #20;
    reset_n = 1;

    // Write a byte to transmit
    #20;
    w_data = 8'hA5;
    wr_uart = 1;
    #10;
    wr_uart = 0;

    // Wait for TX to complete and RX to receive
    wait (!rx_empty);

    #20;
    rd_uart = 1;
    #10;
    rd_uart = 0;

    #100;
    $finish;
  end

endmodule
