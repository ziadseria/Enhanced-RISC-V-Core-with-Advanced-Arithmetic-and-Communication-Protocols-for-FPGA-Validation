`define CLK @(posedge PCLK)

module apb_tb ();
  
	reg 	PCLK;
	reg 	PRESET_n;
 
  reg		READ_WRITE;		// 2'b00 - NOP, 2'b01 - READ, 2'b11 - WRITE
  
	reg 	PSEL_o;
	reg  PENABLE_o;
 	reg  [31:0]	 PADDR_o;
	reg		PWRITE_o;
 	reg  [31:0]  PWDATA_o;
 	reg  [31:0]  PADDR_i = 32'hA000;
 	reg  [31:0] 	PRDATA_i;
 	reg  PREADY_i;
  
  always begin
    PCLK = 1'b0;
    #5;
    PCLK = 1'b1;
    #5;
  end
  
  apb_master APB_MASTER (.*);
  
  initial begin
    PRESET_n = 1'b0;
    READ_WRITE = 2'b00;
    repeat (2) `CLK;
    PRESET_n = 1'b1;
    repeat (2) `CLK;
    
    READ_WRITE = 2'b01;
    `CLK;
    READ_WRITE = 2'b00;
    repeat (4) `CLK;
    
    READ_WRITE = 2'b11;
    `CLK;
    READ_WRITE = 2'b00;
    repeat (4) `CLK;
    $finish();
  end
  
  always @(posedge PCLK or negedge PRESET_n) begin
    if (~PRESET_n)
      PREADY_i <= 1'b0;
    else begin
    if (PSEL_o && PENABLE_o) begin
      PREADY_i <= 1'b1;
      PRDATA_i <= $urandom%32'h20;
    end else begin
      PREADY_i <= 1'b0;
      PRDATA_i <= $urandom%32'hFF;
    end
    end
  end
  
  initial begin
    $dumpfile("apb_master.vcd");
    $dumpvars(2, apb_tb);
  end
  
endmodule

