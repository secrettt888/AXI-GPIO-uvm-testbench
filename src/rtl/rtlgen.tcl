# Args: <ip_name>
# Usage example:
#   vivado -mode batch -source rtlgen.tcl -tclargs axi_gpio

# Defaults
set proj_name rtlgenProject
# set part xc7a35tcsg324-1

# Parse arguments
if { $argc < 1 } {
  puts "ERROR: ip_name argument required."
  puts "Usage: vivado -mode batch -source rtlgen.tcl -tclargs <ip_name>"
  exit 1
}

set ip_name [lindex $argv 0]
set module_name ${ip_name}_0

set proj_dir ./proj_dir

file mkdir $proj_dir
create_project $proj_name $proj_dir -force

# Create and configure the IP
create_ip -name $ip_name -vendor xilinx.com -library ip -version * -module_name $module_name

# set_property -dict [list \
#   CONFIG.C_GPIO_WIDTH       $width \
#   CONFIG.C_IS_DUAL          $dual \
#   CONFIG.C_ALL_INPUTS       $all_inputs \
#   CONFIG.C_ALL_OUTPUTS      $all_outputs \
#   CONFIG.C_INTERRUPT_PRESENT $irq \
# ] [get_ips $module_name]

# Generate the IP products (DCP, HDL stub, etc.)
generate_target all [get_ips $module_name]
export_ip_user_files -of_objects [get_ips $module_name] -no_script -sync -force
create_ip_run [get_ips $module_name]
launch_runs [get_runs ${module_name}_synth_1]
wait_on_run  [get_runs ${module_name}_synth_1]

# Produce a handy instantiation template (verilog/SystemVerilog compatible)
# write_ip_tcl -force $proj_dir/${module_name}_recreate.tcl
#report_ip_status -name ip_status -file $proj_dir/ip_status.rpt
#puts "Done. IP under $proj_dir/. Instantiate '$module_name' in your RTL."
