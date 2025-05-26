class source_base_seq extends uvm_sequence #(source_xtn);

  `uvm_object_utils(source_base_seq)
  tb_config m_cfg;

  // Constructor Declaration
  extern function new(string name="source_base_seq");

 
endclass

// Constructor Definition
function source_base_seq::new(string name="source_base_seq");
  super.new(name);
endfunction


// -----------------------------------------------------------------

class small_payload_seq extends source_base_seq;

  `uvm_object_utils(small_payload_seq)

bit [1:0] addr;
  // Constructor Declaration
  extern function new(string name="small_payload_seq");

  // Body Task Declaration
  extern task body();

endclass

// Constructor Definition
function small_payload_seq::new(string name="small_payload_seq");
  super.new(name);
endfunction

// Body Task Definition
task small_payload_seq::body();
 if(!uvm_config_db#(bit [1:0])::get(null,get_full_name(),"bit[1:0]",addr))
  `uvm_fatal("config","cannot get the addr")
  


 

    req = source_xtn::type_id::create("req");
  
    start_item(req);
    assert(req.randomize() with {header[7:2] inside {[1:17]}; header[1:0] == addr;});
    finish_item(req);

      `uvm_info("RAM_WR_SEQUENCE",$sformatf("printing from sequence \n %s", req.sprint()),UVM_HIGH)



endtask




class mid_payload_seq extends source_base_seq;

  `uvm_object_utils(mid_payload_seq)
bit [1:0] addr;
  // Constructor Declaration
  extern function new(string name="mid_payload_seq");

  // Body Task Declaration
  extern task body();

endclass

// Constructor Definition
function mid_payload_seq::new(string name="mid_payload_seq");
  super.new(name);
endfunction

// Body Task Definition
task mid_payload_seq::body();

  if(!uvm_config_db#(bit [1:0])::get(null,get_full_name(),"bit[1:0]",addr))
  `uvm_fatal("config","cannot get the addr");


   
 req = source_xtn::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {header[7:2] inside {[18:34]}; header[1:0] == addr;});
    finish_item(req);

endtask



class high_payload_seq extends source_base_seq;

  `uvm_object_utils(high_payload_seq)
bit [1:0] addr;
  // Constructor Declaration
  extern function new(string name="high_payload_seq");

  // Body Task Declaration
  extern task body();

endclass

// Constructor Definition
function high_payload_seq::new(string name="high_payload_seq");
  super.new(name);
endfunction

// Body Task Definition
task high_payload_seq::body();
 if(!uvm_config_db#(bit[1:0])::get(null,get_full_name(),"bit[1:0]",addr))
  `uvm_fatal("config","cannot get the addr");

    req = source_xtn::type_id::create("req");
    start_item(req);
    assert(req.randomize() with {header[7:2]==63; header[1:0] == addr;});
    finish_item(req);
`uvm_info("HIGH_PAYLOAD_SEQ", $sformatf("Generated transaction:\n%s", req.sprint()), UVM_HIGH)

endtask



