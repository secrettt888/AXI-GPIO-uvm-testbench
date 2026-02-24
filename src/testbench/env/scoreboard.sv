// Scoreboard: receives observed transactions and checks vs expected
//Scoreboard-ul tine evidenta input-urilor si output-urilor
//Golden model-ul este ca dut-ul
//In simulare, scoreboard-ul primeste output-urile de la dut-ul facut de noi
//si le compara cu cu output-urile de la Golden model(care sunt corecte)
//pachet colectat(dut)vs pachet expected (golden model)
class scoreboard extends uvm_component;
  `uvm_component_utils(scoreboard)

  // Analysis export to connect from monitor
  uvm_analysis_imp #(seq_item, scoreboard) analysis_export;
bit [31:0] axi_addr;
  bit [31:0] axi_data;
  bit axi_write;
  bit axi_addr_valid;
  bit [1:0] axi_resp;
  bit[31:0] reg_map[int unsigned];
 
  covergroup cg_axi;
    cp_addr: coverpoint axi_addr {
      bins addr_0 = {9'h0000};
      bins addr_4 = {9'h0004};
      bins unimplemented = default;
    }
    cp_data: coverpoint axi_data {
      //bins pow2[i] = { 32'(1 << i) } with (i < 32);
      bins pow2[] = {
      32'h0000_0001, 32'h0000_0002, 32'h0000_0004, 32'h0000_0008,
      32'h0000_0010, 32'h0000_0020, 32'h0000_0040, 32'h0000_0080,
      32'h0000_0100, 32'h0000_0200, 32'h0000_0400, 32'h0000_0800,
      32'h0000_1000, 32'h0000_2000, 32'h0000_4000, 32'h0000_8000,
      32'h0001_0000, 32'h0002_0000, 32'h0004_0000, 32'h0008_0000,
      32'h0010_0000, 32'h0020_0000, 32'h0040_0000, 32'h0080_0000,
      32'h0100_0000, 32'h0200_0000, 32'h0400_0000, 32'h0800_0000,
      32'h1000_0000, 32'h2000_0000, 32'h4000_0000, 32'h8000_0000
    };//
    }
    cp_write: coverpoint axi_write {
      bins read = {0};
      bins write = {1};
    }
    cp_valid : coverpoint axi_addr_valid {
      bins valid = {1};
      bins invalid = {0};
    }
    cp_resp : coverpoint axi_resp {
      bins ok = {0};
      bins error = default;
    }
    x_write_valid: cross cp_write, cp_valid;
    x_addr_valid: cross cp_addr, cp_valid;
    x_addr_write_valid: cross cp_addr, cp_write, cp_valid;
  endgroup
 
 
  function new(string name, uvm_component parent);
    super.new(name, parent);
    reg_map['h0000]='0;
    reg_map['h0004]='0;
    reg_map['h0008]='0;
    reg_map['h000C]='0;
    reg_map['h011C]='0;
    reg_map['h0128]='0;
    reg_map['h0120]='0;
    cg_axi =new();
  endfunction
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    analysis_export = new("analysis_export", this);
  endfunction
 
  virtual function bit addr_valid(bit [31:0] addr);
      return reg_map.exists(addr); 
  endfunction
 
  virtual function bit addr_implemented(bit [31:0] addr); 
     // Definim ce adrese verificam efectiv
     if(addr == 32'h0000 || addr == 32'h0004) return 1;    
     else return 0;  
  endfunction
 
virtual function void write(seq_item t);
logic [31:0] exp_data;
 
  if ($isunknown(t.addr)) begin  // verificam adresa si pentru write si read
      `uvm_error("X_Z_CHECK", $sformatf("CRITICAL: Address contains X or Z! Addr: 0x%0h", t.addr))
      return;
  end
      if ($isunknown(t.data)) begin
          `uvm_error("X_Z_CHECK", $sformatf("CRITICAL: Write Data (WDATA) contains X or Z! Data: 0x%0h", t.data))
          return;
      end
 
 
  // write() gets called by the monitor via analysis_port
  if(t.write == 1) begin
       if(addr_valid(t.addr)) begin
          if(addr_implemented(t.addr)) begin
             if(t.addr == 'h0004) begin          //scriere la registrul de control
                reg_map[t.addr] = t.data;
             end
             if(t.addr == 'h0000) begin       //scriere la registrul de date
                for(int i=0; i<32; i++) begin
                   if(reg_map['h0004][i] == 0) begin      //scriem bitul doar daca TRI este 0
                      reg_map['h0000][i] = t.data[i];
                   end
                end
             end
 
          end
       end
    end
  else begin
       if(addr_valid(t.addr)) begin
          if(reg_map[t.addr] !== t.data) begin
             `uvm_error(get_type_name(), $sformatf("MISMATCH! Addr: %h | Expected: %h vs Actual: %h", t.addr, reg_map[t.addr], t.data))
          end else begin
             `uvm_info(get_type_name(), $sformatf("MATCH! Addr: %h Data: %h", t.addr, t.data), UVM_HIGH)
          end
       end
    end
    `uvm_info(get_type_name(), $sformatf("Observed: %s", t.convert2string()), UVM_LOW)
  axi_addr = t.addr;
  axi_data = t.data;
  axi_write = t.write;
  axi_addr_valid = addr_valid(t.addr);
  axi_resp = t.resp;
  cg_axi.sample();
 
  endfunction
endclass : scoreboard
//doi registrii, unul de directie si unul de date

