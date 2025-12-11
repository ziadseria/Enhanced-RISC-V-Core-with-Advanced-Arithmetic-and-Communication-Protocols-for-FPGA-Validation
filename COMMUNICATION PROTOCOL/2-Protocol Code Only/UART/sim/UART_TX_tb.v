`timescale 1ns / 1ps

module UART_TX_tb;

  // Parameters
  localparam DBIT = 8;
  localparam SB_TICK = 16;

  // DUT signals
  reg clk;
  reg reset_n;
  reg tx_start;
  reg s_tick;
  reg [DBIT - 1:0] tx_din;
  wire tx;
  wire tx_done_tick;

  // Instantiate DUT
  UART_TX #(
    .DBIT(DBIT),
    .SB_TICK(SB_TICK)
  ) uut (
    .clk(clk),
    .reset_n(reset_n),
    .tx_start(tx_start),
    .s_tick(s_tick),
    .tx_din(tx_din),
    .tx(tx),
    .tx_done_tick(tx_done_tick)
  );

  // Generate clock (10ns period = 100 MHz)
  always begin
    clk = 0; #5;
    clk = 1; #5;
  end

  // Generate s_tick (simulate 16x oversampling clock)
  reg [7:0] s_tick_counter = 0;
  always begin
    #20; // slow down tick for visibility in simulation
    s_tick = 1;
    #10;
    s_tick = 0;
  end

  // Stimulus
  initial begin
    // Initial state
    clk = 0;
    reset_n = 0;
    tx_start = 0;
    s_tick = 0;
    tx_din = 8'b10101010; // send AAh
    #25;

    // Release reset
    reset_n = 1;
    #20;

    // Send data
    tx_start = 1;
    #10;
    tx_start = 0;

    // Wait enough time for full transmission:
    // total ticks = (1 start + 8 data + 1 stop) * 16 = 160 ticks × tick time
    #4000;

    $finish;
  end

  // VCD dump for GTKWave
  initial begin
    $dumpfile("UART_TX_tb.vcd");
    $dumpvars(0, UART_TX_tb);
  end

endmodule
