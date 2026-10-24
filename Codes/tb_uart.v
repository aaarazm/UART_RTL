`timescale 1ns/1ns

module tb_uart();
    
    reg clk, rst,/*  Rx,  */transmit_start;
    reg [7:0] data_i;
`ifdef PARITY_ENABLE
    wire parity_error;
`endif
    wire frame_error, Tx, transmit_ready, receive_ready, receive_valid;
    wire [7:0] data_o;

    localparam clk_period_ns = 1000 / `CLK_FREQ_MHZ;
    initial clk = 0;
    always #(clk_period_ns/2) clk = ~clk;

    uart uut(
        .clk(clk),
        .rst(rst),
        .Rx(Tx), // echo test
        .Tx(Tx),
        .transmit_ready(transmit_ready),
        .receive_ready(receive_ready),
        .transmit_start(transmit_start),
        .data_i(data_i),
        .data_o(data_o),
        .receive_valid(receive_valid),
`ifdef PARITY_ENABLE
        .parity_error(parity_error),
`endif
        .frame_error(frame_error)
    );

    initial begin
        rst = 0; transmit_start = 0; data_i = 8'b11111110;
        @(posedge uut.tick)
        #(50*clk_period_ns + 13) rst = 1;
        #(clk_period_ns) rst = 0;
        #(clk_period_ns) transmit_start = 1;
        #(clk_period_ns) transmit_start = 1;
        #(clk_period_ns) transmit_start = 0;
        #(clk_period_ns) data_i = 8'b01010101;
        @(posedge transmit_ready) #(2*clk_period_ns) transmit_start = 1;
        #(clk_period_ns) transmit_start = 0;
        @(posedge transmit_ready) #(200*clk_period_ns) $stop;
    end

endmodule