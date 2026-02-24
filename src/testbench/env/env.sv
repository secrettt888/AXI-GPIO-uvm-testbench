// Environment: instantiates agent and scoreboard and connects analysis

class env extends uvm_env;
  `uvm_component_utils(env)

  my_agent   agt;
  scoreboard scb;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    agt = my_agent  ::type_id::create("agt", this);
    scb = scoreboard::type_id::create("scb", this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    agt.mon.ap.connect(scb.analysis_export);
  endfunction
endclass : env

