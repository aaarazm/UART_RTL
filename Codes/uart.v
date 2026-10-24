module uart(
    clk, rst, Rx, Tx, transmit_ready, receive_ready, transmit_start, data_i, data_o, receive_valid,
`ifdef PARITY_ENABLE
    parity_error,
`endif
    frame_error
);

    input clk, rst, Rx, transmit_start;
    input [7:0] data_i; 
`ifdef PARITY_ENABLE
    output parity_error;
`endif
    output frame_error, Tx, transmit_ready, receive_ready, receive_valid;
    output [7:0]  data_o;

    wire tick;

    baudgen baudgen_inst (.clk(clk), .enable(1'b1), .tick(tick));

    uart_receiver receiver_inst(
        .clk(clk),
        .tick(tick),
        .rst(rst),
        .rx(Rx),
`ifdef PARITY_ENABLE
        .parity_error(parity_error),
`endif
        .frame_error(frame_error),
        .ready_o(receive_ready),
        .valid_o(receive_valid),
        .data_o(data_o)
    );

    uart_transmitter transmitter_inst(
        .clk(clk),
        .tick(tick),
        .rst(rst),
        .start(transmit_start),
        .tx(Tx),
        .ready_o(transmit_ready),
        .data_i(data_i)
    );
    
endmodule