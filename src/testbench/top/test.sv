// Example UVM test that builds env and starts a sequence

class base_test extends uvm_test;
  `uvm_component_utils(base_test)

  env m_env;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    m_env = env::type_id::create("m_env", this);
  endfunction

  virtual task run_phase(uvm_phase phase);
    basic_sequence seq;
    
    phase.raise_objection(this);

    // Start a basic sequence on the agent's sequencer
    seq = basic_sequence::type_id::create("seq");
    if (m_env.agt.is_active == UVM_ACTIVE) begin
      seq.start(m_env.agt.seqr);
    end

    // TODO: Add end-of-test conditions / timeouts
    #1000ns;

    phase.drop_objection(this);
  endtask
endclass : base_test

