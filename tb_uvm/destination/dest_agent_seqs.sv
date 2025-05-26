class dest_base_seq extends uvm_sequence #(dest_xtn);

`uvm_object_utils(dest_base_seq)
tb_config m_cfg;


extern function new(string name= "dest_base_seq");
extern task body();
endclass


function dest_base_seq::new(string name= "dest_base_seq");
super.new(name);
endfunction

task dest_base_seq::body();
if(!uvm_config_db #(tb_config) :: get(null,get_full_name(),"m_cfg",m_cfg))
	`uvm_fatal(get_type_name(),"getting is failed")

endtask






class normal_seq extends dest_base_seq;
`uvm_object_utils(normal_seq)

function new(string name="normal_seq");
super.new(name);
endfunction


task body();
super.body();



	req= dest_xtn :: type_id :: create("req");
	start_item(req);
	assert(req.randomize() with {cycles <30;});
	finish_item(req);

endtask
endclass
	

class soft_reset_seq extends dest_base_seq;
`uvm_object_utils(soft_reset_seq)

function new(string name="soft_reset_seq");
super.new(name);
endfunction


task body();
super.body();


	req= dest_xtn :: type_id :: create("req");
	start_item(req);
	assert(req.randomize() with {cycles >30;});
	finish_item(req);


endtask
endclass
	
