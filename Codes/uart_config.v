`define CLK_FREQ_MHZ 50
`define OVERSAMPLING
`define PARITY_ENABLE
`define BAUD_RATE 115200

`ifdef OVERSAMPLING
    `define OVERSAMPLING_FACTOR 16 // Either 16 or 8 (not 4 yet!)
`endif
