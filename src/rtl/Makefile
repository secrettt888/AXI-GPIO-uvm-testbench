# Usage:
#   make ip_name=axi_gpio sources
#   make clean

ip_name ?=

.PHONY: gen sources

sources:
	@if [ -z "$(ip_name)" ]; then echo "ERROR: specify ip_name, e.g. make ip_name=axi_gpio gen"; exit 1; fi
	@echo "Running Vivado to generate RTL for $(ip_name)"
	vivado -mode batch -source rtlgen.tcl -tclargs $(ip_name)
	@module_name="$(ip_name)_0"; \
	 src_dir=./proj_dir/rtlgenProject.gen/sources_1/ip/$$module_name/hdl; \
	 if [ ! -d "$$src_dir" ]; then echo "ERROR: Expected HDL dir not found: $$src_dir"; exit 2; fi; \
	 echo "Copying HDL from $$src_dir to ."; \
	 cp -f $$src_dir/* .; \
	 echo "Removing proj_dir and other logs"; \
	 rm -rf ./proj_dir ./vivado.jou ./vivado.log ./.Xil/

clean:
	@echo "Cleaning generated files..."
	@find . -maxdepth 1 -type f ! -name 'Makefile' ! -name 'rtlgen.tcl' -print -delete
	@rm -rf ./proj_dir .Xil vivado.log vivado.jou
