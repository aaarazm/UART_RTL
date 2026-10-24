`define OVERSAMPLING

module uart_transmitter(
    clk, tick, rst, start, tx,
    ready_o, data_i
);
    input clk, tick, rst, start;
    output reg ready_o, tx;

`ifdef PARITY_ENABLE
    reg par_bit;
`endif
    input [7:0] data_i;

    reg [2:0] data_counter;
    reg [2:0] ps, ns;
    reg [7:0] shift_reg;
    reg shift_en, shift_init, data_ctr_en, data_ctr_init, keep_frame_err;

    localparam [2:0] idle = 0, init_state = 1, start_bit = 2, data_transmit = 3, parity_send = 4, end_bit = 5;

`ifdef OVERSAMPLING
    localparam tx_ctr_width = $clog2(`OVERSAMPLING_FACTOR);
    // localparam middle_num = (`OVERSAMPLING_FACTOR / 2) - 1;
    // localparam mid_ctr_width = $clog2(`middle_num);
    // reg [mid_ctr_width:0] middle_counter;
    reg [tx_ctr_width-1:0] tx_tick_counter;
    reg tx_ctr_init, tx_ctr_en /* , threebit_start */;
    // wire threebit_ready, tx_maj;
    // threebitmaj (.tick(tick), .start(threebit_start), .rx(rx), .maj(tx_maj), .ready(threebit_ready));
`endif

    // Main FSM

    always @(posedge clk) begin
        ns <= idle;
        case (ps)
            idle: ns <= start ? init_state:idle;
            init_state: ns <= tick ? start_bit:init_state;
            start_bit: begin
                ns <= (tick
`ifdef OVERSAMPLING
                 && (tx_tick_counter == (`OVERSAMPLING_FACTOR - 1))
`endif
                 ) ? data_transmit:start_bit;
            end
            data_transmit: begin
                ns <= (tick
`ifdef OVERSAMPLING
                && (tx_tick_counter == (`OVERSAMPLING_FACTOR - 1))
`endif
                && (data_counter == 3'b111)) ? 
`ifdef PARITY_ENABLE
                  parity_send:
`else
                  end_bit:
`endif
                  data_transmit;
            end
`ifdef PARITY_ENABLE
            parity_send: begin
                ns <= (tick 
`ifdef OVERSAMPLING
                && (tx_tick_counter == (`OVERSAMPLING_FACTOR - 1))
`endif
                ) ? end_bit:parity_send;
            end
`endif
            end_bit: begin
                ns <= (tick 
`ifdef OVERSAMPLING
                && (tx_tick_counter == (`OVERSAMPLING_FACTOR - 1))
`endif
                ) ? idle:end_bit;
            end
        endcase
    end

    // Control Signals

    always @(*) begin
        data_ctr_en <= 1'b0;
        data_ctr_init <= 1'b0;
        // shift_init <= 1'b0;
        shift_en <= 1'b0;
        ready_o <= 1'b0;
        tx <= 1'b1;
        // valid_o <= 1'b0;
`ifdef OVERSAMPLING
        tx_ctr_init <= 1'b0;
        tx_ctr_en <= 1'b0;
        threebit_start <= 1'b0;
`endif
// `ifdef PARITY_ENABLE
//         parity_error <= 0;
// `endif
        case (ps)
            idle: begin
`ifdef OVERSAMPLING
                tx_ctr_init <= 1'b1;
`endif
// `ifdef PARITY_ENABLE
//                 parity_error <= keep_par_err;
// `endif
                // frame_error <= keep_frame_err;
                data_ctr_init <= 1'b1;
                // shift_init <= 1'b1;
                ready_o <= 1'b1;
            end
            // init_state:
`ifdef OVERSAMPLING
            start_bit: begin
                tx <= 1'b0;
                tx_ctr_en <= 1'b1;
                // threebit_start <= (tx_tick_counter == middle_num) ? 1'b1:1'b0;
            end
`endif
            data_transmit: begin
`ifdef OVERSAMPLING
                tx_ctr_en <= 1'b1;
                // threebit_start <= (tx_tick_counter == middle_num) ? 1'b1:1'b0;
                shift_en <= (tx_tick_counter == (`OVERSAMPLING_FACTOR - 1)) ? 1'b1:1'b0;
`else
                shift_en <= 1'b1;
`endif
                data_ctr_en <= 1'b1;
                tx <= shift_reg[0];
            end

`ifdef PARITY_ENABLE
            parity_send: begin
`ifdef OVERSAMPLING
                tx_ctr_en <= 1'b1;
                threebit_start <= (tx_tick_counter == middle_num) ? 1'b1:1'b0;
                if (threebit_ready & (par_bit != tx_maj)) keep_par_err = 1;
`else
                if (tick & (par_bit != rx)) keep_par_err = 1;
`endif
            end
`endif
            end_bit: begin
                keep_frame_err = 0;
`ifdef PARITY_ENABLE
                parity_error <= keep_par_err;
`endif
`ifdef OVERSAMPLING
                tx_ctr_en <= 1'b1;
                threebit_start <= (tx_tick_counter == middle_num) ? 1'b1:1'b0;
                if (threebit_ready & (!tx_maj)) keep_frame_err = 1;
`else
                if (tick & (!rx)) keep_frame_err = 1;
`endif
            end
        endcase
    end

`ifdef OVERSAMPLING
    always @(posedge tick) begin
        if (tx_ctr_init) tx_tick_counter = 0;
        else if (tx_ctr_en) tx_tick_counter = tx_tick_counter + 1;
    end
`endif

    always @(posedge tick) begin
        if (data_ctr_init) data_counter = 0;
        else if (data_ctr_en && (tx_tick_counter = (`OVERSAMPLING_FACTOR - 1))) data_counter = data_counter + 1;
    end

    always @(posedge clk) begin
        if(ready_o & start) begin
            shift_reg = data_i;
`ifdef PARITY_ENABLE
            par_bit = 0;
`endif
        end

        else if (shift_en & tick) begin
`ifdef PARITY_ENABLE
            par_bit = par_bit ^ shift_reg[0]; // Blocking code gets the updated version of shiftreg[0] which is tx 
`endif
            shift_reg = {1'b0, shift_reg[7:1]};
        end
    end

endmodule
