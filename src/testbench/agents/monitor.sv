// Monitor: samples DUT interface and publishes transactions via analysis_port
// Este asemanator cu driver-ul, insa rolul acestuia este de a 
// monitoriza daca ce este transmis este corect
class my_monitor extends uvm_component;
  `uvm_component_utils(my_monitor)

  virtual my_if vif;

  uvm_analysis_port #(seq_item) ap;// transferam pachete catre scoreboard

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction

  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    ap = new("ap", this);
    if (!uvm_config_db#(virtual my_if)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "virtual interface not set for monitor");
  endfunction

  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    fork
      monitor_write();
      monitor_read();
    join_none// fork functioneaza astfel ca un backround process, nu se blocheaza verificarea in punctul asta
  endtask : run_phase
virtual task monitor_write();
forever begin
seq_item tr = seq_item::type_id::create("tr");
bit x,y;
  x=0;
  y=0;
         forever  begin
          @(vif.mon_cb);
          if(vif.s_axi_awready&&vif.s_axi_awvalid)begin
            tr.addr=vif.s_axi_awaddr;
            `uvm_info(get_type_name(), $sformatf("Captured Write Addr: %0h", tr.addr), UVM_NONE);
            x=1;
          end
          
          if(vif.s_axi_wready&&vif.s_axi_wvalid)begin
            tr.data=vif.s_axi_wdata;
            `uvm_info(get_type_name(), $sformatf("Captured Write Data: %0h", tr.data), UVM_NONE);
            y=1;
          end
          if(x&&y&&vif.s_axi_bready&&vif.s_axi_bvalid)begin
            tr.resp=vif.s_axi_bresp;
            `uvm_info(get_type_name(), $sformatf("Captured Write Response: %0h", tr.resp), UVM_NONE);
            ap.write(tr);
            break;
        end
end
end
endtask: monitor_write

virtual task monitor_read();
forever begin
seq_item tr = seq_item::type_id::create("tr");
bit x,y;
  x=0;
  y=0;
         forever  begin
          @(vif.mon_cb);
          if(vif.s_axi_arready&&vif.s_axi_arvalid)begin
            tr.addr=vif.s_axi_araddr;
            `uvm_info(get_type_name(), $sformatf("Captured Read Addr: %0h", tr.addr), UVM_NONE);
            x=1;
          end
          if(vif.s_axi_rready&&vif.s_axi_rvalid)begin
            tr.data=vif.s_axi_rdata;
             `uvm_info(get_type_name(), $sformatf("Captured Read Data: %0h", tr.data), UVM_NONE);
            y=1;
            end
          if(x&&y)begin
            ap.write(tr);
            break;
          end
          end
end
endtask: monitor_read
endclass : my_monitor
//pentru verificare putem pune un tr.print() 
//in monitor se face verificarea protocolului: output-ul
//ex. se aserteaza awready, apoi awvalid, sa mai stea asertat un clock cylce, iar apoi sa devina 0 iar
//In monitor, de regula, se fac verificari la nivel de tranzactie, verificam daca semnalele sunt in regula
//in scoreboard facem verificari la nivel de date, adrese etc.
//monitorul funcioneaza pe baza protocolului
//monitorul si scoreboard-ul nu sunt interdependente intern
