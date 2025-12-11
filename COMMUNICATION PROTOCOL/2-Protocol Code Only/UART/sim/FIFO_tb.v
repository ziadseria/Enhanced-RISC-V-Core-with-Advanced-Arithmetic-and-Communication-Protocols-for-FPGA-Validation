`timescale 1ns/1ps

module FIFO_tb;

  reg clk;
  reg rst;
  reg wr;
  reg rd;
  reg [7:0] data_in;

  wire [7:0] data_out;
  wire empty;
  wire full;

  // Instantiate the FIFO
  FIFO uut (
    .clk(clk),
    .rst(rst),
    .wr(wr),
    .rd(rd),
    .data_in(data_in),
    .data_out(data_out),
    .empty(empty),
    .full(full)
  );

  // Clock generation
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Stimulus
  initial begin
    // Initial values
    rst = 0;
    wr = 0;
    rd = 0;
    data_in = 8'd0;

    // Apply reset
    #12;
    rst = 1;
    $display("Time=%0t Apply Reset Done", $time);

    // ---------------------------------------------
    // Try reading from empty FIFO (underflow test)
    // ---------------------------------------------
    rd = 1;
    #10;
    rd = 0;
    $display("Time=%0t Tried reading from empty FIFO", $time);

    // ---------------------------------------------
    // Write 8 elements
    // ---------------------------------------------
    $display("Time=%0t Start writing to FIFO", $time);
    wr = 1;
    data_in = 8'hA1; #10;
    data_in = 8'hA2; #10;
    data_in = 8'hA3; #10;
    data_in = 8'hA4; #10;
    data_in = 8'hA5; #10;
    data_in = 8'hA6; #10;
    data_in = 8'hA7; #10;
    data_in = 8'hA8; #10;
    wr = 0;
    $display("Time=%0t Done writing 8 elements", $time);

    // ---------------------------------------------
    // Try writing when FIFO is full (overflow test)
    // ---------------------------------------------
    wr = 1;
    data_in = 8'hFF;
    #10;
    wr = 0;
    $display("Time=%0t Tried writing when FIFO is full", $time);

    // ---------------------------------------------
    // Read 8 elements
    // ---------------------------------------------
    $display("Time=%0t Start reading from FIFO", $time);
    rd = 1; #10;
    rd = 1; #10;
    rd = 1; #10;
    rd = 1; #10;
    rd = 1; #10;
    rd = 1; #10;
    rd = 1; #10;
    rd = 1; #10;
    rd = 0;
    $display("Time=%0t Done reading 8 elements", $time);

    // ---------------------------------------------
    // Try reading again (underflow again)
    // ---------------------------------------------
    rd = 1; #10;
    rd = 0;
    $display("Time=%0t Tried reading from empty FIFO again", $time);

    // Finish simulation
    #50;
    $finish;
  end

  // Waveform dump
  initial begin
    $dumpfile("FIFO_tb.vcd");
    $dumpvars(0, FIFO_tb);
  end

endmodule
