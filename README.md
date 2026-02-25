# AXI-GPIO UVM Verification Environment

## 📌 Overview
This repository contains a fully automated **Universal Verification Methodology (UVM)** environment for an AXI-GPIO (General Purpose Input/Output) IP block. 

The project utilizes a **mixed-language simulation flow**:
* **Design Under Test (DUT):** Written in **VHDL** (Auto-extracted from Xilinx Vivado IP catalog).
* **UVM Testbench:** Written in **SystemVerilog**.

## 🏗️ UVM Testbench Architecture



The verification environment is built using standard UVM 1.2 components:
* **`base_test`**: Instantiates the UVM environment and starts the default sequences.
* **`env`**: Encapsulates the AXI-GPIO agents and the scoreboard.
* **`agent`**: Contains the active/passive components interfacing with the VHDL DUT:
  * **Sequencer:** Routes sequence items to the driver.
  * **Driver:** Translates SystemVerilog UVM transactions into physical AXI4-Lite and GPIO pin-level wiggles.
  * **Monitor:** Observes the bus and broadcasts sampled transactions via analysis ports.
* **`scoreboard`**: Compares expected transactions against the actual observed outputs to verify data integrity.

## 📂 Directory Structure
```text
axi-gpio-uvm-testbench/
├── src/                      
│   ├── rtl/                  # Auto-generated VHDL DUT files
│   └── testbench/            # SystemVerilog UVM TB files
│       ├── if/               # SV Interfaces (e.g., my_if.sv)
│       ├── top/              # TB top module (top.sv)
│       └── uvm_pkg/          # UVM components, sequences, and tests
└── run/                      # Scripts and Simulation execution
    ├── sim/                  # Working directory for compiled DBs & waves
    ├── Makefile              # Automation wrapper
    ├── run.sh                # Bash run script
    ├── run_sim.tcl           # Vivado TCL mixed-language driver
    └── files.f               # Filelist for compilation order
