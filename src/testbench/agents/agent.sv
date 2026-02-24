// Agent: bundles sequencer, driver, monitor. Active drives, passive only monitors.

class my_agent extends uvm_agent;
  `uvm_component_utils(my_agent)

  // Configuration knob
  uvm_active_passive_enum is_active = UVM_ACTIVE;

  // Sub-components
  my_sequencer   seqr;
  my_driver      drv;
  my_monitor     mon;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    // TODO: Pull is_active from config DB if needed
    // uvm_config_db#(uvm_active_passive_enum)::get(this, "", "is_active", is_active);

    if (is_active == UVM_ACTIVE) begin
      seqr = my_sequencer ::type_id::create("seqr", this);
      drv  = my_driver    ::type_id::create("drv",  this);
    end
    mon    = my_monitor   ::type_id::create("mon",  this);
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (is_active == UVM_ACTIVE) begin
      drv.seq_item_port.connect(seqr.seq_item_export);
    end
  endfunction
endclass : my_agent

