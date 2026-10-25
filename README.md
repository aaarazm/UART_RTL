# UART RTL Simulation
I only used ChatGPT to make this guide and the makefile at /sim :D
## Requirements
- QuestaSim/ModelSim with `vlog`, `vsim`, and `vlib` available in your terminal.
- GNU Make.

## Running the Simulation

From the project root:

```bash
cd sim
make
```

This compiles the Verilog sources, launches the simulator GUI, loads `wave.do`, and runs the testbench (`tb_uart`).

Other commands:

```bash
make compile  # Compile only
make run      # Compile and run in GUI mode
make batch    # Run in terminal mode and exit
make clean    # Remove generated simulation files
```

## Configuration (`uart_config.v`)

This file defines global Verilog macros used to configure the UART:

| Macro | Description |
|---|---|
| `CLK_FREQ_MHZ` | System clock frequency in MHz (50 MHz) |
| `OVERSAMPLING` | Enables receiver oversampling |
| `OVERSAMPLING_FACTOR` | Oversampling factor (16 when enabled; 8 is also supported) |
| `PARITY_ENABLE` | Enables parity checking/generation |
| `BAUD_RATE` | UART baud rate (115200 baud) |

Modify these definitions to change the UART configuration. The `OVERSAMPLING_FACTOR` is defined only when `OVERSAMPLING` is enabled.

