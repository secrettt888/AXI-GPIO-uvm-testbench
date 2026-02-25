# AXI-GPIO UVM Verification Environment

## 📌 Overview
This repository contains a fully automated **Universal Verification Methodology (UVM)** environment for an AXI-GPIO (General Purpose Input/Output) IP block. 

## 🏗️ UVM Testbench Architecture



The verification environment is built using standard UVM 1.2 components:
* **`base_test`**: Instantiates the UVM environment and starts the default sequences.
* **`env`**: Encapsulates the AXI-GPIO agents and the scoreboard.
* **`agent`**: Interfaces with the VHDL DUT, containing:
  * **Sequencer:** Routes sequence items to the driver.
  * **Driver:** Translates SV transactions into physical AXI4-Lite and GPIO pin wiggles.
  * **Monitor:** Observes the bus and broadcasts sampled transactions via analysis ports.
* **`scoreboard`**: Verifies data integrity by comparing actual DUT outputs against a SystemVerilog **golden reference model** (predictor) that mimics the expected AXI-GPIO behavior.

## 📂 Directory Structure
```text
axi-gpio-uvm-testbench/
├── src/                      
│   ├── rtl/                  # IP generation scripts (rtlgen.tcl) and imported VHDL DUT files
│   └── testbench/            # SystemVerilog UVM TB files
│       ├── if/               # SV Interfaces (e.g., my_if.sv)
│       ├── top/              # TB top module (top.sv)
│       └── uvm_pkg/          # UVM components, sequences, and tests
└── run/                      # Scripts and Simulation execution
    ├── sim/                  # Working dir for compiled DBs & waves
    │   └── run_sim.tcl       # Vivado TCL mixed-language driver
    ├── Makefile              # Automation wrapper
    ├── run.sh                # Bash run script
    └── files.f               # Filelist for compilation order
