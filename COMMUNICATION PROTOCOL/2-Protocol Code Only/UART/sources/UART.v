`timescale 1ns / 1ps

module UART #(parameter DBIT = 8,     // Number of data bits
                        SB_TICK = 16  // Number of stop bit ticks
             )     
    (
        input clk, reset_n,

        // Receiver port
        output [DBIT - 1: 0] r_data,
        input rd_uart,
        output rx_empty,
        input rx,
        
        // Transmitter port
        input [DBIT - 1: 0] w_data,
        input wr_uart,
        output tx_full,
        output tx,

        // Baud rate generator
        input [10: 0] TIMER_FINAL_VALUE
    );

    // ------------------------------
    // Baud Rate Generator
    // ------------------------------
    wire tick;

    BaudRate_Generator #(.BITS(11)) baud_gen (
        .clk(clk),
        .reset_n(reset_n),
        .enable(1'b1),
        .FINAL_VALUE(TIMER_FINAL_VALUE),
        .done(tick)
    );

    // ------------------------------
    // UART Receiver
    // ------------------------------
    wire rx_done_tick;
    wire [DBIT - 1: 0] rx_dout;

    UART_RX #(.DBIT(DBIT), .SB_TICK(SB_TICK)) receiver (
        .clk(clk),
        .reset_n(reset_n),
        .rx(rx),
        .s_tick(tick),
        .rx_done_tick(rx_done_tick),
        .rx_dout(rx_dout)
    );

    // RX FIFO
    FIFO rx_FIFO (
        .clk(clk),
        .rst(~reset_n),
        .data_in(rx_dout),
        .wr(rx_done_tick),
        .rd(rd_uart),
        .data_out(r_data),
        .full(),         // Not connected
        .empty(rx_empty)
    );

    // ------------------------------
    // UART Transmitter
    // ------------------------------
    wire tx_fifo_empty, tx_done_tick;
    wire [DBIT - 1: 0] tx_din;

    UART_TX #(.DBIT(DBIT), .SB_TICK(SB_TICK)) transmitter (
        .clk(clk),
        .reset_n(reset_n),
        .tx_start(~tx_fifo_empty),
        .s_tick(tick),
        .tx_din(tx_din),
        .tx_done_tick(tx_done_tick),
        .tx(tx)
    );

    // TX FIFO
    FIFO tx_FIFO (
        .clk(clk),
        .rst(~reset_n),
        .data_in(w_data),
        .wr(wr_uart),
        .rd(tx_done_tick),
        .data_out(tx_din),
        .full(tx_full),
        .empty(tx_fifo_empty)
    );

endmodule
