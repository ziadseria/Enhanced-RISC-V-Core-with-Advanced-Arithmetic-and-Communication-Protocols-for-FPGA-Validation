`timescale 1ns / 1ps
//Hossam Ahmed Ali Seyam _ Mansoura University 

module FIFO(
    input [7:0] data_in, 
    input clk, rst, rd, wr,
    output empty, full, 
    output reg [7:0] data_out
    );

    reg [3:0] fifo_count;              // Number of elements currently in the FIFO
    reg [2:0] rd_ptr, wr_ptr;          // Read and Write pointers (3-bit for 8-depth FIFO)
    reg [7:0] fifo_ram [0:7];          // FIFO memory array with 8 elements of 8-bit width

    assign empty = (fifo_count == 0);  // FIFO is empty when count is 0
    assign full  = (fifo_count == 8);  // FIFO is full when count reaches 8

    // Write operation: write data_in to memory at write pointer if not full
    always @(posedge clk) begin
        if (!rst)
            ; // Do nothing on reset
        else if (wr && !full)
            fifo_ram[wr_ptr] <= data_in;
    end

    // Read operation: read data from memory at read pointer if not empty
    always @(posedge clk) begin
        if (!rst)
            data_out <= 0;
        else if (rd && !empty)
            data_out <= fifo_ram[rd_ptr];
    end

    // Update read and write pointers
    always @(posedge clk) begin
        if (!rst) begin
            wr_ptr <= 0;
            rd_ptr <= 0;
        end else begin
            if (wr && !full)
                wr_ptr <= wr_ptr + 1;
            if (rd && !empty)
                rd_ptr <= rd_ptr + 1;
        end
    end

    // Update FIFO count based on write and read operations
    always @(posedge clk) begin
        if (!rst)
            fifo_count <= 0;
        else begin
            case ({wr, rd})
                2'b10: if (!full)  fifo_count <= fifo_count + 1; // write only
                2'b01: if (!empty) fifo_count <= fifo_count - 1; // read only
                default: fifo_count <= fifo_count;              // no change or simultaneous read/write
            endcase
        end
    end

endmodule
