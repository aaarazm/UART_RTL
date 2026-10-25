#   make run       - launch Questa/ModelSim GUI and run until $stop (or finish)
#   make batch     - run in console mode and exit afterward
#   make compile   - compile only
#   make clean     - remove generated simulation files

VLOG ?= vlog
VSIM ?= vsim
VLIB ?= vlib
TOP  ?= tb_uart
WORK ?= work

CODE_DIR := ../Codes
SOURCES := \
	$(CODE_DIR)/uart_config.v \
	$(CODE_DIR)/baudgen.v \
	$(CODE_DIR)/threebitmaj.v \
	$(CODE_DIR)/uart_receiver.v \
	$(CODE_DIR)/uart_transmitter.v \
	$(CODE_DIR)/uart.v \
	$(CODE_DIR)/tb_uart.v

.PHONY: all compile run batch clean

all: run

compile:
	@if [ ! -d "$(WORK)" ]; then $(VLIB) $(WORK); fi
	$(VLOG) -work $(WORK) -mfcu $(SOURCES)

# GUI mode: run -all; when $stop is reached, the simulator pauses interactively.
run: compile
	$(VSIM) -voptargs=+acc -lib $(WORK) $(TOP) -do "do wave.do; log -r sim:/$(TOP)/*; run -all"

# Console mode: run until $stop / simulation end, then exit the simulator.
batch: compile
	$(VSIM) -c -lib $(WORK) $(TOP) -do "run -all; quit -f"

clean:
	rm -rf $(WORK) transcript vsim.wlf gate_work
