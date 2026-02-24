// Default sequencer bridging sequences to the driver

class my_sequencer extends uvm_sequencer #(seq_item);
  `uvm_component_utils(my_sequencer)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction
endclass : my_sequencer

