module threebitmaj (tick, start, rx, maj, ready);
    input tick, start, rx;
    output maj;
    output reg ready;

    reg [1:0] counter;
    reg [1:0] shifter;

    always @(posedge tick) begin
        counter <= 2'b00;
        ready <= 1'b0;
        if (start) begin
            shifter <= {rx, shifter[1]};
            counter <= 2'b01;
        end
        else if (counter == 2'b01) begin
            shifter <= {rx, shifter[1]};
            counter <= 2'b10;
        end
        else if (counter == 2'b10) begin
            ready <= 1'b1;
            counter <= 2'b00;
        end
    end
    assign maj = (shifter[0]&shifter[1]) | (shifter[1]&rx) | (shifter[0]&rx);
endmodule
