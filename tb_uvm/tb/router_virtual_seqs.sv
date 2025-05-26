class virtual_sequence_base extends uvm_sequence #(uvm_sequence_item);

`uvm_object_utils(virtual_sequence_base)

router_virtual_seqr v_seqr;

source_agent_sequencer src_agt_seqr[];
dest_agent_sequencer dst_agt_seqr[];

tb_config m_cfg;

bit [1:0]addr;

function new(string name="virtual_sequence_base");
super.new(name);
endfunction

task body();
if(!$cast(v_seqr,m_sequencer))
	`uvm_fatal(get_type_name(),"casting is failed")


if(!uvm_config_db #(tb_config) :: get(null,get_full_name(),"m_cfg",m_cfg))
	`uvm_fatal(get_type_name(),"getting is failed")

 dst_agt_seqr = new[m_cfg.no_of_dst_agents];
 src_agt_seqr= new[m_cfg.no_of_src_agents];



foreach(dst_agt_seqr[i])
	dst_agt_seqr[i] = v_seqr.dst_agt_seqr[i];

foreach(src_agt_seqr[i])
	src_agt_seqr[i] = v_seqr.src_agt_seqr[i];


endtask
endclass
//=======================================

class small_v_seq extends virtual_sequence_base;

`uvm_object_utils(small_v_seq)

small_payload_seq s_seqh;
normal_seq d_seqh;

function new(string name="small_v_seq");
super.new(name);
endfunction

task body();
super.body();

if(!uvm_config_db#(bit [1:0])::get(null,get_full_name(),"bit[1:0]",addr))
  `uvm_fatal("config","cannot get the addr");


s_seqh = small_payload_seq :: type_id :: create("s_seqh");
d_seqh = normal_seq :: type_id :: create("d_seqh");

fork
s_seqh.start(src_agt_seqr[0]);
d_seqh.start(dst_agt_seqr[addr]);
join

endtask

endclass

//=======================================

class mid_v_seq extends virtual_sequence_base;

`uvm_object_utils(mid_v_seq)

mid_payload_seq s_seqh;
normal_seq d_seqh;
function new(string name="mid_v_seq");
super.new(name);
endfunction

task body();
super.body();
if(!uvm_config_db#(bit [1:0])::get(null,get_full_name(),"bit[1:0]",addr))
  `uvm_fatal("config","cannot get the addr");


s_seqh = mid_payload_seq :: type_id :: create("s_seqh");
d_seqh = normal_seq :: type_id :: create("d_seqh");

fork
s_seqh.start(src_agt_seqr[0]);
d_seqh.start(dst_agt_seqr[addr]);
join


endtask

endclass

//=======================================

class high_v_seq extends virtual_sequence_base;

`uvm_object_utils(high_v_seq)

high_payload_seq s_seqh;
normal_seq d_seqh;
function new(string name="high_v_seq");
super.new(name);
endfunction

task body();
super.body();
if(!uvm_config_db#(bit [1:0])::get(null,get_full_name(),"bit[1:0]",addr))
  `uvm_fatal("config","cannot get the addr");


s_seqh = high_payload_seq :: type_id :: create("s_seqh");
d_seqh = normal_seq :: type_id :: create("d_seqh");

fork
s_seqh.start(src_agt_seqr[0]);
d_seqh.start(dst_agt_seqr[addr]);
join


endtask

endclass