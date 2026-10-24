module baudgen(clk, enable, tick);

    input clk, enable;
    output reg tick;
    // parameter CLK_FREQ_MHZ = 50, BAUD_RATE = 115200, OVERSAMPLING_FACTOR = 16;

`ifdef OVERSAMPLING
    localparam tick_rate = `CLK_FREQ_MHZ * 1000000 / (`BAUD_RATE * `OVERSAMPLING_FACTOR);
`else
    localparam tick_rate = `CLK_FREQ_MHZ * 1000000 / (`BAUD_RATE);
`endif

    localparam countBits = $clog2(tick_rate);

    reg [countBits-1:0] counter;

    reg ns, ps;

    localparam rollOver = 0, counting = 1;

    always @(ps, enable, counter) begin
        ns = rollOver;
        case(ps)
            rollOver: ns = enable ? counting : rollOver;

            counting: ns = (counter < tick_rate) ? counting : rollOver;
        endcase
    end

    always @(posedge clk) begin
        tick = (counter == tick_rate) ? 1'b1 : 1'b0;
        case(ps)
            rollOver: counter <= 0;
            counting: counter <= (counter + 1);
        endcase
    end

    always @(posedge clk) begin
        ps <= ns;
    end

endmodule
