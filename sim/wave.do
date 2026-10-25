onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group Transmitter /tb_uart/uut/transmitter_inst/tx_ctr_width
add wave -noupdate -expand -group Transmitter /tb_uart/uut/transmitter_inst/clk
add wave -noupdate -expand -group Transmitter /tb_uart/uut/transmitter_inst/tick
add wave -noupdate -expand -group Transmitter /tb_uart/uut/transmitter_inst/rst
add wave -noupdate -expand -group Transmitter /tb_uart/uut/transmitter_inst/start
add wave -noupdate -expand -group Transmitter /tb_uart/uut/transmitter_inst/ready_o
add wave -noupdate -expand -group Transmitter /tb_uart/uut/transmitter_inst/tx
add wave -noupdate -expand -group Transmitter /tb_uart/uut/transmitter_inst/par_bit
add wave -noupdate -expand -group Transmitter /tb_uart/uut/transmitter_inst/data_i
add wave -noupdate -expand -group Transmitter /tb_uart/uut/transmitter_inst/data_counter
add wave -noupdate -expand -group Transmitter /tb_uart/uut/transmitter_inst/ps
add wave -noupdate -expand -group Transmitter /tb_uart/uut/transmitter_inst/ns
add wave -noupdate -expand -group Transmitter -radix binary /tb_uart/uut/transmitter_inst/shift_reg
add wave -noupdate -expand -group Transmitter /tb_uart/uut/transmitter_inst/shift_en
add wave -noupdate -expand -group Transmitter /tb_uart/uut/transmitter_inst/data_ctr_en
add wave -noupdate -expand -group Transmitter /tb_uart/uut/transmitter_inst/data_ctr_init
add wave -noupdate -expand -group Transmitter /tb_uart/uut/transmitter_inst/tx_tick_counter
add wave -noupdate -expand -group Transmitter /tb_uart/uut/transmitter_inst/tx_ctr_init
add wave -noupdate -expand -group Transmitter /tb_uart/uut/transmitter_inst/tx_ctr_en
add wave -noupdate /tb_uart/uut/baudgen_inst/tick
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/rx_ctr_width
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/clk
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/tick
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/rst
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/rx
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/frame_error
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/ready_o
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/valid_o
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/parity_error
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/keep_par_err
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/par_bit
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/data_o
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/data_counter
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/ps
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/ns
add wave -noupdate -expand -group Receiver -radix binary /tb_uart/uut/receiver_inst/shift_reg
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/shift_en
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/shift_init
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/data_ctr_en
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/data_ctr_init
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/keep_frame_err
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/keep_valid
add wave -noupdate -expand -group Receiver -radix unsigned /tb_uart/uut/receiver_inst/rx_tick_counter
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/rx_ctr_init
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/rx_ctr_en
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/threebit_start
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/threebit_ready
add wave -noupdate -expand -group Receiver /tb_uart/uut/receiver_inst/rx_maj
add wave -noupdate /tb_uart/uut/baudgen_inst/tick
add wave -noupdate -expand -group {Baud Gen} /tb_uart/uut/baudgen_inst/tick_rate
add wave -noupdate -expand -group {Baud Gen} /tb_uart/uut/baudgen_inst/countBits
add wave -noupdate -expand -group {Baud Gen} /tb_uart/uut/baudgen_inst/rollOver
add wave -noupdate -expand -group {Baud Gen} /tb_uart/uut/baudgen_inst/counting
add wave -noupdate -expand -group {Baud Gen} /tb_uart/uut/baudgen_inst/clk
add wave -noupdate -expand -group {Baud Gen} /tb_uart/uut/baudgen_inst/enable
add wave -noupdate -expand -group {Baud Gen} /tb_uart/uut/baudgen_inst/tick
add wave -noupdate -expand -group {Baud Gen} /tb_uart/uut/baudgen_inst/counter
add wave -noupdate -expand -group {Baud Gen} /tb_uart/uut/baudgen_inst/ns
add wave -noupdate -expand -group {Baud Gen} /tb_uart/uut/baudgen_inst/ps
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {103850 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 170
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {220427 ns}
