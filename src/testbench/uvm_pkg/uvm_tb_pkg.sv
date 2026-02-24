// Central UVM testbench package. Import this in the simulation compile list.

package uvm_tb_pkg;
  import uvm_pkg::*;
  `include "uvm_macros.svh"

  // Forward includes — order matters for dependencies
  // Interface is compiled separately via filelist (no include here)
  // Sequences
  `include "../sequences/seq_item.sv"
  `include "../sequences/sequence.sv"

  // Agent components
  `include "../agents/seqr.sv"
  `include "../agents/driver.sv"
  `include "../agents/monitor.sv"
  `include "../agents/agent.sv"

  // Environment
  `include "../env/scoreboard.sv"
  `include "../env/env.sv"

  // Test(s)
  `include "../top/test.sv"
endpackage : uvm_tb_pkg
