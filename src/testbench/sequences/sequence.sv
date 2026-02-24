// Basic example sequence that produces seq_item transactions

class basic_sequence extends uvm_sequence #(seq_item);
  `uvm_object_utils(basic_sequence)

  // TODO: Parameterize with knobs (num_items, randomization control, etc.)
  int unsigned num_items = 10;
  rand logic [8:0] addr;
  rand logic [31:0] data;
  rand logic        write;
  // TODO: Add constrain
  constraint c_default {
    addr>=0;
    addr<='h100;
    addr%4==0;
  }
  function new(string name = "basic_sequence");
    super.new(name);
  endfunction

  virtual task body();// this function is made to determine how the transactions are made adn sent
    `uvm_info(get_type_name(), $sformatf("Starting sequence with %0d items", num_items), UVM_NONE)
    // Advance time to avoid all activity at t=0
    repeat (num_items) begin
      if(!this.randomize()) `uvm_error(get_type_name(), "Sequence randomization failed");
      req = seq_item::type_id::create("req");
      start_item(req);
      // TODO: Randomize or fill fields as needed
      // fucntia asta este facuta cu constraint  si de fapt inseamna:
      // pun conditia ca daca randomizarea nu s-a facut confrom constrainturilor enuntate mai sus,
      //sa imi dea erroare. De asemenea se pune un constraint si pe aceasta conditie. Can se randomizeaza
      // stimulii, randomizare efectuata de sequence utilizand seq_item, adresa generata de sequence trebuie sa 
      // fie atribuita adresei sequence itemului.
      //Asadar, 'local' este folosit ca lui addr(care este de fapt adresa lui seq_item) sa i se atribuie adresa
      // randomizata aici, de catre sequence.
      
       if (!req.randomize() with {
        addr==local :: addr;
        data==local ::data;
        write==local:: write;
       })`uvm_error(get_type_name(), "Randomization failed");

    
      // TODO: Optionally set fields before finish_item
      finish_item(req);
    end
  endtask : body
endclass : basic_sequence
