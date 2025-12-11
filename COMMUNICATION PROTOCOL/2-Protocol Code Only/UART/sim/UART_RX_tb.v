`timescale 1ns / 1ps

module UART_RX_tb;

  // Parameters
  localparam DBIT = 8;
  localparam SB_TICK = 16;

  // Testbench Signals
  reg clk;
  reg reset_n;
  reg rx;
  reg s_tick;

  wire rx_done_tick;
  wire [DBIT-1:0] rx_dout;

  // Instantiate the UART_RX module
  UART_RX #(.DBIT(DBIT), .SB_TICK(SB_TICK)) dut (
    .clk(clk),
    .reset_n(reset_n),
    .rx(rx),
    .s_tick(s_tick),
    .rx_done_tick(rx_done_tick),
    .rx_dout(rx_dout)
  );

  // Clock generation: 100 MHz (10ns period)
  always begin
    clk = 1; #5;
    clk = 0; #5;
  end

  // s_tick generation: one pulse every 16 clock cycles
  reg [3:0] s_counter = 0;
  always @(posedge clk) begin
    if (!reset_n) begin
      s_counter <= 0;
      s_tick <= 0;
    end else begin
      if (s_counter == 15) begin
        s_counter <= 0;
        s_tick <= 1;
      end else begin
        s_counter <= s_counter + 1;
        s_tick <= 0;
      end
    end
  end

  // Test sequence
  initial begin
    $dumpfile("UART_RX_tb.vcd");
    $dumpvars(0, UART_RX_tb);

    // Initialize signals
    reset_n = 0;
    rx = 1; // idle state
    #50;

    reset_n = 1;
    #100;

    // Send UART byte: 0xA5 = 8'b10100101
    // UART frame: start(0) + 8 data bits (LSB first) + stop(1)
    send_uart_byte(8'b10100101);

    // Wait for reception to complete
    #3000;

    $finish;
  end

  // Task to send a UART frame (start, data, stop)
  task send_uart_byte(input [7:0] data);
    integer i;
    begin
      // Send start bit (0)
      @(posedge clk); rx <= 0;
      repeat(16) @(posedge clk);

      // Send 8 data bits (LSB first)
      for (i = 0; i < 8; i = i + 1) begin
        @(posedge clk); rx <= data[i];
        repeat(16) @(posedge clk);
      end

      // Send stop bit (1)
      @(posedge clk); rx <= 1;
      repeat(16) @(posedge clk);
    end
  endtask

endmodule
