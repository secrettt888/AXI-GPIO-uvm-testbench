// Driver: pulls seq_item from sequencer and drives DUT interface

class my_driver extends uvm_driver #(seq_item);
  `uvm_component_utils(my_driver)

  // TODO: Add virtual interface handle(s) to drive DUT pins
  virtual my_if vif;

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  // Get interface via config DB
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "virtual interface not set for driver")
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    vif.s_axi_awvalid <= 0;
    vif.s_axi_wvalid  <= 0;
    vif.s_axi_arvalid <= 0;
    vif.s_axi_bready  <= 0;
    vif.s_axi_rready  <= 0;
    forever begin
      // Advance time in loop to avoid zero-time deadlock
      seq_item req;
      seq_item rsp;
      wait(vif.s_axi_aresetn==1);
      seq_item_port.get_next_item(req);
      rsp = seq_item::type_id::create("rsp");
      @(posedge vif.s_axi_aclk);
      if(req.write==1)begin
       
       vif.s_axi_awaddr<=req.addr;
       vif.s_axi_wdata<=req.data;
       vif.s_axi_awvalid<=1;
       vif.s_axi_wvalid<=1;
       vif.s_axi_bready<=1;
       wait (vif.s_axi_awready==1);
        @(posedge vif.s_axi_aclk); 
       vif.s_axi_awaddr<=0;
       vif.s_axi_awvalid<=0;
       wait (vif.s_axi_wready==1);
        @(posedge vif.s_axi_aclk);
        vif.s_axi_wdata<=0;
        vif.s_axi_wvalid<=0;
       wait(vif.s_axi_bvalid==1);
       @(posedge vif.s_axi_aclk);
       vif.s_axi_bready=0;
       rsp.resp=vif.s_axi_bresp;
       rsp.write=1;
       req.print();
      end
      else begin
        vif.s_axi_araddr<=req.addr;
        vif.s_axi_arvalid<=1;
        vif.s_axi_rready<=1;
        wait(vif.s_axi_arready==1);
        @(posedge vif.s_axi_aclk);
        vif.s_axi_arvalid<=0;
        wait(vif.s_axi_rvalid==1);
         @(posedge vif.s_axi_aclk);
        rsp.data=vif.s_axi_rdata;
        rsp.resp=vif.s_axi_rresp;
        vif.s_axi_rready<=0;
        rsp.write=0;
        req.print();
      end
      seq_item_port.item_done();
       end
  endtask : run_phase
endclass : my_driver
