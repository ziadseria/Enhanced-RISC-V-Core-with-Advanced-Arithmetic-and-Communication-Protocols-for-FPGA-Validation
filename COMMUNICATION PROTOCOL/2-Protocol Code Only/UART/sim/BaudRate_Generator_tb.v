`timescale 1ns / 1ps
// Hossam Ahmed Ali Seyam _ Mansoura University

module BaudRate_Generator_tb();

  // DUT signals
  reg clk;
  reg reset_n;
  reg enable;
  reg [9:0] FINAL_VALUE;  // 10-bit counter

  wire done;

  // Instantiate the DUT
  BaudRate_Generator #(10) uut (
    .clk(clk),
    .reset_n(reset_n),
    .enable(enable),
    .FINAL_VALUE(FINAL_VALUE),
    .done(done)
  );

  // Clock generation: 10ns period (100 MHz)
  always begin
    clk = 0;
    #5;
    clk = 1;
    #5;
  end

  initial begin
    // Step 1: Initial state
    reset_n = 0;
    enable = 0;
    FINAL_VALUE = 10'd10;  // Count up to 10
    #20;

    // Step 2: Release reset
    reset_n = 1;
    #10;

    // Step 3: Start timer
    enable = 1;
    $display("Time=%0t ns: Timer started", $time);

    // Wait to see multiple done pulses
    repeat (50) begin
      @(posedge clk);
      $display("Time=%0t ns: done = %b", $time, done);
    end

    // Step 4: Disable timer
    enable = 0;
    $display("Time=%0t ns: Timer disabled", $time);
    #50;

    // Step 5: Apply reset again
    reset_n = 0;
    $display("Time=%0t ns: Reset asserted", $time);
    #20;
    reset_n = 1;
    $display("Time=%0t ns: Reset released", $time);

    #50;
    $finish;
  end

  // Dump waveform for GTKWave
  initial begin
    $dumpfile("baudrate_gen_tb.vcd");
    $dumpvars(0, BaudRate_Generator_tb);
  end

endmodule
