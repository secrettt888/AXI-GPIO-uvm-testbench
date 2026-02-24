# Usage examples:
#   make run_sim                  # batch run
#   make run_sim GUI=1            # GUI run
#   make run_sim TIME=100us       # limit sim time (batch)
#   make run_sim ARGS='+UVM_TESTNAME=base_test +seed=1'  # plusargs
#   make clean

.PHONY: run_sim clean gui sources view

# Variables
GUI ?= 0
VIEW ?= 0
TIME ?=
ARGS ?=

RUN_DIR := $(abspath .)

# IP generation variables (from rtl Makefile)
ip_name ?=

run_sim:
	@echo "Running Vivado xsim via run_sim.tcl..."
	@if [ "$(GUI)" = "1" ]; then MODE="gui"; else MODE="batch"; fi; \
	 if [ -n "$(TIME)" ] && [ "$$MODE" = "batch" ]; then TIME_ARGS="sim_time $(TIME)"; else TIME_ARGS=""; fi; \
	 if [ "$(VIEW)" = "1" ]; then VIEW_ARGS="view 1"; else VIEW_ARGS=""; fi; \
	 vivado -mode batch -nolog -nojournal -notrace -source run_sim.tcl -tclargs mode $$MODE $$TIME_ARGS $$VIEW_ARGS $(ARGS)

clean:
	@echo "Cleaning simulation artifacts..."
	@rm -rf ./sim ./logs ./.Xil || true
gui:
	@$(MAKE) run_sim GUI=1

view:
	@$(MAKE) run_sim GUI=1 VIEW=1

# Generate VHDL/Verilog sources from Vivado IP
sources:
	@if [ -z "$(ip_name)" ]; then echo "ERROR: specify ip_name, e.g. make sources ip_name=axi_gpio"; exit 1; fi
	@echo "Running Vivado to generate RTL for $(ip_name)"
	cd ../src/rtl && vivado -mode batch -source rtlgen.tcl -tclargs $(ip_name)
	@module_name="$(ip_name)_0"; \
	 hdl_dir="../src/rtl/proj_dir/rtlgenProject.gen/sources_1/ip/$$module_name/hdl"; \
	 synth_dir="../src/rtl/proj_dir/rtlgenProject.gen/sources_1/ip/$$module_name/synth"; \
	 if [ ! -d "$$hdl_dir" ]; then echo "ERROR: Expected HDL dir not found: $$hdl_dir"; exit 2; fi; \
	 echo "Copying HDL from $$hdl_dir to ../src/rtl"; \
	 cp -f $$hdl_dir/* ../src/rtl/; \
	 if [ -d "$$synth_dir" ]; then \
	   echo "Copying synth wrapper(s) from $$synth_dir to ../src/rtl"; \
	   cp -f $$synth_dir/* ../src/rtl/; \
	 else \
	   echo "No synth dir found at $$synth_dir (skipping)"; \
	 fi; \
	 echo "Updating run/files.f with generated VHDL from ../src/rtl (prepended, de-duplicated)"; \
	 vhdl_list=$$(ls -1 ../src/rtl/*.vhd 2>/dev/null); \
	 if [ -n "$$vhdl_list" ]; then \
	   tmpf=$$(mktemp); \
	   { printf "# Auto-added generated IP VHDL (do not edit by hand)\n"; echo "$$vhdl_list"; echo; cat files.f; } | \
	   awk '!seen[$$0]++' > $$tmpf; \
	   mv $$tmpf files.f; \
	 else \
	   echo "No .vhd files found to add to files.f"; \
	 fi; \
	 echo "Removing proj_dir and logs"; \
	 rm -rf ../src/rtl/proj_dir ../src/rtl/.Xil ../src/rtl/vivado.log ../src/rtl/vivado.jou
