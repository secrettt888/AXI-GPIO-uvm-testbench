// Basic sequence item (transaction)

class seq_item extends uvm_sequence_item;
  `uvm_object_utils(seq_item)

  // TODO: Declare transaction fields, e.g. addr, data, op, etc.
  rand logic [8:0] addr;
  rand logic[31:0] data;
  rand  logic  write;//1=write, 0=read
  logic [1:0] resp;// de tinut ont la monitorizare ca trebuie sa fie logic,nu bit
  //== compara doar numere (cum este 0 si 1)
  //ca sa comparam si Xsi y, avem nevoie DE ===
  // TODO: Add constraints for valid transactions
  constraint c_default { 
    addr>=0;
    addr<='h100; 
    addr%4==0;
   }
   virtual function print();
      `uvm_info(get_type_name(), $sformatf("Sequence item with address: %h , data: %h , is_write = %b", addr, data, write), UVM_MEDIUM)
    endfunction

  function new(string name = "seq_item");
    super.new(name);
  endfunction

  // TODO: Implement do_copy if custom deep copy is needed
 virtual function void do_copy(uvm_object rhs);
    seq_item rhs_; if(!$cast(rhs_, rhs)) `uvm_fatal(get_name(), "cast failed")
    // a sequence item is created and then the,
    super.do_copy(rhs);
    addr=rhs_.addr;
    data=rhs_.data;
    write=rhs_.write;
  endfunction

  // TODO: Implement do_compare for scoreboarding if needed
   virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
     seq_item rhs_; if(!$cast(rhs_, rhs)) return 0;
     do_compare = super.do_compare(rhs, comparer);
     if(addr!=rhs_.addr)
     begin
     do_compare=0;
     end
     if(data!=rhs_.data)
     begin
     do_compare=0;
     end

     // compare fields
  endfunction

  // Optional: pretty printing
  function string convert2string();
    // TODO: customize as needed
    return $sformatf("seq_item()");
  endfunction
endclass : seq_item

