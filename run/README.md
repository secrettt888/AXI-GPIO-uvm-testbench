Vivado 2024.2 Simulation Scripts

Overview
- `Makefile` — primary entrypoint; wraps Vivado xsim via `run_sim.tcl`.
- `run_sim.tcl` — projectless xsim flow; compiles VHDL (xvhdl) then SV (xvlog), elaborates, runs or launches GUI, handles waves.
- `files.f` — filelist. Add your RTL and TB paths here; generated VHDL can be auto-prepended via the `sources` target.

Quick Start
- Batch simulation:
  - `make -C run run_sim`
- GUI simulation (re-simulate with GUI):
  - `make -C run gui`
- View existing waves without re-simulating (opens `run/sim/xsim.wdb`):
  - `make -C run view` or `make -C run run_sim GUI=1 VIEW=1`
- Limit batch simulation time (example 100us):
  - `make -C run run_sim TIME=100us`
- Pass UVM plusargs (example test name):
  - `make -C run run_sim ARGS='+UVM_TESTNAME=base_test'`
- Clean run artifacts (`run/sim`, `run/logs`, `.Xil` under run):
  - `make -C run clean`

Generate IP RTL Sources
- Generate Vivado IP and copy VHDL into `src/rtl`, then prepend to `run/files.f`:
  - `make -C run sources ip_name=axi_gpio`
  - Uses `src/rtl/rtlgen.tcl`. After generation, VHDL files under `src/rtl` are prepended to `run/files.f` so they compile first.

Notes
- UVM: The flow links the `uvm` library for compile/elab. Ensure UVM macros are included in your sources (e.g., ``include "uvm_macros.svh"`).
- Waves: Batch runs create `run/sim/xsim.wdb`. GUI mode can either re-simulate with waves or open the existing WDB via `make -C run view`.
