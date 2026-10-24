module uart_receiver(
    clk, tick, rst, rx,
`ifdef PARITY_ENABLE
    parity_error,
`endif
    frame_error, ready_o, valid_o, data_o
);
    input clk, tick, rst, rx;
    output reg frame_error, ready_o, valid_o;
`ifdef PARITY_ENABLE
    output reg parity_error;
    reg keep_par_err, par_bit;
`endif
    output [7:0] data_o;

    reg [3:0] data_counter;
    reg [2:0] ps, ns;
    reg [7:0] shift_reg;
    reg shift_en, shift_init, data_ctr_en, data_ctr_init, keep_frame_err, keep_valid;

    localparam [2:0] idle = 0, /* init_state = 1, */ start_bit = 1, data_receive = 2, parity_check = 3, end_bit = 4;

`ifdef OVERSAMPLING
    localparam rx_ctr_width = $clog2(`OVERSAMPLING_FACTOR);
    localparam middle_num = (`OVERSAMPLING_FACTOR / 2) - 1;
    // localparam mid_ctr_width = $clog2(`middle_num);
    // reg [mid_ctr_width:0] middle_counter;
    reg [rx_ctr_width-1:0] rx_tick_counter;
    reg rx_ctr_init, rx_ctr_en, threebit_start;
    wire threebit_ready, rx_maj;
    threebitmaj majority_inst(.tick(tick), .start(threebit_start), .rx(rx), .maj(rx_maj), .ready(threebit_ready));
`endif

    // Main FSM

    always @(/* posedge clk */*) begin
        ns <= idle;
        case (ps)
            idle: begin
                ns <= (!rx && tick) ?
`ifdef OVERSAMPLING
                start_bit:
`else
                data_receive:
`endif
                idle;
            end
// `ifdef OVERSAMPLING
//             init_state: begin
//                 ns <= (tick && (rx_tick_counter == (`OVERSAMPLING_FACTOR - 1))
//                 ) ? start_bit:init_state;
//             end
// `endif
`ifdef OVERSAMPLING
            start_bit: begin
                ns <= (tick && threebit_ready && rx_maj) ? idle:
                (tick && (rx_tick_counter == (`OVERSAMPLING_FACTOR - 1))) ? data_receive:start_bit;
            end
`endif
            data_receive: begin
                ns <= (tick
`ifdef OVERSAMPLING
                 && (rx_tick_counter == (`OVERSAMPLING_FACTOR - 1))
                //  && (rx_tick_counter == 0)
`endif
                  && (data_counter == 4'b1000)) ? 
`ifdef PARITY_ENABLE
                  parity_check:
`else
                  end_bit:
`endif
                  data_receive;
            end
`ifdef PARITY_ENABLE
            parity_check: begin
                ns <= (tick 
`ifdef OVERSAMPLING
                && (rx_tick_counter == (`OVERSAMPLING_FACTOR - 1))
`endif
                ) ? end_bit:parity_check;
            end
`endif
            end_bit: begin
                ns <= (tick 
`ifdef OVERSAMPLING
                && (rx_tick_counter == (`OVERSAMPLING_FACTOR - 1))
`endif
                ) ? idle:end_bit;
            end
        endcase
    end

    // Control Signals

    always @(*) begin
        data_ctr_en <= 1'b0;
        data_ctr_init <= 1'b0;
        shift_init <= 1'b0;
        shift_en <= 1'b0;
        frame_error <= 1'b0;
        ready_o <= 1'b0;
        valid_o <= 1'b0;
`ifdef OVERSAMPLING
        rx_ctr_init <= 1'b0;
        rx_ctr_en <= 1'b0;
        threebit_start <= 1'b0;
`endif
`ifdef PARITY_ENABLE
        parity_error <= 0;
`endif
        case (ps)
            idle: begin
`ifdef OVERSAMPLING
                rx_ctr_init <= 1'b1;
`endif
`ifdef PARITY_ENABLE
                parity_error <= keep_par_err;
`endif
                frame_error <= keep_frame_err;
                valid_o <= keep_valid;
                data_ctr_init <= 1'b1;
                shift_init <= 1'b1;
                ready_o <= 1'b1;
            end
            // init_state:
`ifdef OVERSAMPLING
            start_bit: begin
                keep_valid <= 1'b0;
                rx_ctr_en <= 1'b1;
                threebit_start <= (rx_tick_counter == middle_num) ? 1'b1:1'b0;
            end
`endif
            data_receive: begin
`ifdef OVERSAMPLING
                rx_ctr_en <= 1'b1;
                threebit_start <= (rx_tick_counter == middle_num) ? 1'b1:1'b0;
                shift_en <= threebit_ready ? 1'b1:1'b0;
`else
                shift_en <= 1'b1;
`endif
                keep_valid <= 1'b0;
                data_ctr_en <= 1'b1;
                // keep_par_err <= 1'b0;
            end

`ifdef PARITY_ENABLE
            parity_check: begin
                // keep_par_err = 0;
`ifdef OVERSAMPLING
                rx_ctr_en <= 1'b1;
                threebit_start <= (rx_tick_counter == middle_num) ? 1'b1:1'b0;
                if (threebit_ready) begin
                    keep_par_err = (par_bit != rx_maj) ? 1'b1:1'b0;
                end
`else
                keep_par_err = (tick & (par_bit != rx)) ? 1'b1:1'b0;
`endif
            end
`endif
            end_bit: begin
                // keep_frame_err = 0;
`ifdef PARITY_ENABLE
                parity_error <= keep_par_err;
                keep_valid <= ~(keep_par_err | keep_frame_err);
`else
                keep_valid <= ~(keep_frame_err);
`endif
`ifdef OVERSAMPLING
                rx_ctr_en <= 1'b1;
                threebit_start <= (rx_tick_counter == middle_num) ? 1'b1:1'b0;
                if (threebit_ready) begin
                    keep_frame_err = rx_maj ? 1'b0:1'b1;
                end
`else
                keep_frame_err = (tick & (~rx)) ? 1'b1:1'b0;
`endif
            end
        endcase
    end

`ifdef OVERSAMPLING
    always @(posedge tick) begin
        if (rx_ctr_init) rx_tick_counter = 0;
        else if (rx_ctr_en) rx_tick_counter = rx_tick_counter + 1;
    end
`endif

    always @(posedge tick) begin
        if (data_ctr_init) data_counter = 0;
        else if (data_ctr_en
`ifdef OVERSAMPLING
         & (rx_tick_counter == (`OVERSAMPLING_FACTOR - 1))
`endif
         ) data_counter = data_counter + 1;
    end

    always @(posedge tick) begin
        if (shift_init) begin
            shift_reg = shift_reg;
`ifdef PARITY_ENABLE
            par_bit = 0;
`endif
        end
        else if (shift_en) begin
            shift_reg =
`ifdef OVERSAMPLING
        {rx_maj, shift_reg[7:1]};
`else
        {rx, shift_reg[7:1]};
`endif
`ifdef PARITY_ENABLE
        par_bit = par_bit ^ shift_reg[7]; // Blocking code gets the updated version of shiftreg[7] which is either rx_maj or rx 
`endif
        end
    end

    always @(posedge clk) begin
        if(rst) ps <= idle;
        else ps <= ns;
    end

    assign data_o = shift_reg;
    
endmodule
