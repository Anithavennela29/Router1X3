

class router_base_test extends uvm_test;

    //Factory registration
    `uvm_component_utils(router_base_test)

    //declaring no of source and destination agents
    int no_of_src_agents = 1;
    int no_of_dst_agents = 3;

    //handles for source,destination and env configs
    source_agent_config src_cfg[];
    dest_agent_config dst_cfg[];
    tb_config m_cfg;

    //handle for router_env 
    router_env envh;
    router_virtual_seqr v_seqr;

bit [1:0] address;
    extern function new(string name="router_base_test",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern function void start_of_simulation_phase(uvm_phase phase);
    
endclass

//constructor new method
function router_base_test::new(string name="router_base_test",uvm_component parent);
    super.new(name,parent);
endfunction

//build phase method of router_base_test
function void router_base_test::build_phase(uvm_phase phase);
    `uvm_info("INFO","This is the build phase of test",UVM_LOW)
    //create a memory for env config
    m_cfg = tb_config::type_id::create("m_cfg");
    // initialize the dynamic array of source config equal to no_of_src_agents
    src_cfg = new[no_of_src_agents];
    // for all the configuration objects, set the following parameters 
	// is_active to UVM_ACTIVE
    foreach(src_cfg[i])
        begin
            //creating an instance for source_agent_config using src_cfg
            src_cfg[i] = source_agent_config::type_id::create($sformatf("src_cfg[%0d]",i));
            
		    // Get the virtual interface from the config database
            if(!uvm_config_db #(virtual router_if) :: get(this,"",$sformatf("src_if%0d",i),src_cfg[i].vif))
                `uvm_fatal("CONFIG","Unable to get the uvm_config_db. Have you set it?")
            src_cfg[i].is_active = UVM_ACTIVE;

        end
    // initialize the dynamic array of dest config equal to no_of_dest_agents
    dst_cfg = new[no_of_dst_agents];
    // for all the configuration objects, set the following parameters
    // is_active to UVM_ACTIVE
    foreach(dst_cfg[i])
        begin
            //creating an instance for dest_agent_config using dest_cfg
            dst_cfg[i] = dest_agent_config::type_id::create($sformatf("dst_cfg[%0d]",i));

            //get the virtual interface from the config database
            if(!uvm_config_db #(virtual router_if) :: get(this,"",$sformatf("dst_if%0d",i),dst_cfg[i].vif))
                `uvm_fatal("CONFIG","Unable to get the router interface. Have you set it?")
            dst_cfg[i].is_active = UVM_ACTIVE;
        end
    
    //connecting the source and dest configs to env configs
    m_cfg.src_cfg = src_cfg;
    m_cfg.dst_cfg = dst_cfg;

    //properties connection with the env configs
    m_cfg.no_of_src_agents = no_of_src_agents;
    m_cfg.no_of_dst_agents = no_of_dst_agents;

    // set the env config object into UVM config DB  
	uvm_config_db #(tb_config)::set(this,"*","m_cfg",m_cfg);

    //create a memory for env
    envh = router_env::type_id::create("envh",this);
    super.build_phase(phase);

endfunction

//
function void router_base_test::start_of_simulation_phase(uvm_phase phase);
    super.start_of_simulation_phase(phase);
    uvm_top.print_topology;
endfunction


class small_payload_test extends router_base_test;
`uvm_component_utils(small_payload_test)
small_v_seq v_seq;

extern function new(string name="small_payload_test",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);
endclass

function small_payload_test::new(string name="small_payload_test",uvm_component parent);
super.new(name,parent);
endfunction


function void small_payload_test::build_phase(uvm_phase phase);
//address=0;
super.build_phase(phase);
//uvm_config_db #(bit [1:0])::set(this,"*","bit[1:0]",address);

endfunction

task small_payload_test::run_phase(uvm_phase phase);

v_seq = small_v_seq :: type_id :: create("v_seq");

address=0;
uvm_config_db #(bit [1:0])::set(this,"*","bit[1:0]",address);

phase.raise_objection(this);
//repeat(2)
//begin

v_seq.start(envh.v_seqr);

//end
//#100;
phase.drop_objection(this);

endtask



class mid_payload_test extends router_base_test;
`uvm_component_utils(mid_payload_test)
mid_v_seq v_seq;


extern function new(string name="mid_payload_test",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

function mid_payload_test::new(string name="mid_payload_test",uvm_component parent);
super.new(name,parent);
endfunction

function void mid_payload_test::build_phase(uvm_phase phase);
//address=0;
super.build_phase(phase);
//uvm_config_db #(bit [1:0])::set(this,"*","bit[1:0]",address);

endfunction

task mid_payload_test::run_phase(uvm_phase phase);
v_seq = mid_v_seq :: type_id :: create("v_seq");

if (v_seq == null)
    `uvm_fatal("SEQ_NULL", "mid_v_seq creation failed")
address=1;
uvm_config_db #(bit [1:0])::set(this,"*","bit[1:0]",address);

phase.raise_objection(this);
v_seq.start(envh.v_seqr);

phase.drop_objection(this);

endtask




class high_payload_test extends router_base_test;

`uvm_component_utils(high_payload_test)


high_v_seq v_seq;

extern function new(string name="high_payload_test",uvm_component parent);
extern function void build_phase(uvm_phase phase);
extern task run_phase(uvm_phase phase);

endclass

function high_payload_test::new(string name="high_payload_test",uvm_component parent);
super.new(name,parent);
endfunction


function void high_payload_test::build_phase(uvm_phase phase);
//address=0;
super.build_phase(phase);
//uvm_config_db #(bit [1:0])::set(this,"*","bit[1:0]",address);

endfunction

task high_payload_test::run_phase(uvm_phase phase);
v_seq = high_v_seq :: type_id :: create("v_seq");

address=2;

uvm_config_db #(bit [1:0])::set(this,"*","bit[1:0]",address);

phase.raise_objection(this);
//fork
v_seq.start(envh.v_seqr);
//join

phase.drop_objection(this);

endtask

