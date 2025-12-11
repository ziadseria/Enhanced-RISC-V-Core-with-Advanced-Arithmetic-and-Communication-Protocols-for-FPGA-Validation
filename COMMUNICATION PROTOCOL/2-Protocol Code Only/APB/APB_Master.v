module apb_master (
  input  PCLK,
  input  PRESET_n,
 
  input  READ_WRITE,		// 2'b00 - NOP, 2'b01 - READ, 2'b11 - WRITE
  
  output  PSEL_o,
  output  PENABLE_o,
  output  [31:0]  PADDR_o,
  output  PWRITE_o,
  output  [31:0]  PWDATA_o,
  input  [31:0]  PADDR_i,
  input  [31:0]	 PRDATA_i,
  input  PREADY_i
  
);
  
  parameter[1:0] IDLE_STATE = 2'b00, SETUP_STATE = 2'b01, ACCESS_STATE = 2'b10;
  
  reg[1:0] current_state;
  reg[1:0] next_state;
  
  reg next_PWRITE;
  reg PWRITE;
  
  reg [31:0] next_PRDATA;
  reg [31:0] PRDATA;
  
  always @(posedge PCLK or negedge PRESET_n)
    if (~PRESET_n)
      current_state <= IDLE_STATE;
  	else
      current_state <= next_state;
  
  always @* begin
    next_PWRITE = PWRITE;
    next_PRDATA = PRDATA;
    case (current_state)
      IDLE_STATE:
        if (READ_WRITE[0]) begin
          next_state = SETUP_STATE;
          next_PWRITE = READ_WRITE[1];
        end else begin
          next_state = IDLE_STATE;
        end
      SETUP_STATE: next_state = ACCESS_STATE;
      ACCESS_STATE:
        if (PREADY_i) begin
          if (~PWRITE)
            next_PRDATA = PRDATA_i;
          next_state = IDLE_STATE;
        end else
          next_state = ACCESS_STATE;
      default: next_state = IDLE_STATE;
    endcase
  end
  
  assign apb_state_access = (current_state == ACCESS_STATE);
  assign apb_state_setup = (current_state == SETUP_STATE);
  
  assign PSEL_o = apb_state_setup | apb_state_access;
  assign PENABLE_o = apb_state_access;
  
  assign PADDR_o = {32{apb_state_access}} & PADDR_i;
  
  always @(posedge PCLK or negedge PRESET_n)
    if (~PRESET_n)
      PWRITE <= 1'b0;
  	else
      PWRITE <= next_PWRITE;
  
  assign PWRITE_o = PWRITE;
  
  assign PWDATA_o = {32{apb_state_access}} & PRDATA;
  
  
  always @(posedge PCLK or negedge PRESET_n)
    if (~PRESET_n)
      PRDATA <= 32'h0;
  	else
      PRDATA <= next_PRDATA;
  
endmodule


