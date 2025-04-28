

class router_virtual_seqr extends uvm_sequencer #(uvm_sequence_item);

    //factory registration
    `uvm_component_utils(router_virtual_seqr)

    //handles for source and destination agent sequencers with dynamic array
    source_agent_sequencer src_agt_seqr[];
    dest_agent_sequencer dst_agt_seqr[];

    //handle for router env config
    tb_config m_cfg;

    extern function new(string name = "router_virtual_seqr",uvm_component parent);
    extern function void build_phase(uvm_phase phase);

endclass

//constructor new method
function router_virtual_seqr::new(string name = "router_virtual_seqr",uvm_component parent);
    super.new(name,parent);
endfunction

//build phase of router virtual sequencer
function void router_virtual_seqr::build_phase(uvm_phase phase);
    `uvm_info("INFO","This is the build phase of router virtual sequencer",UVM_LOW)
    // get the config object router env config using uvm_config_db 

	if(!uvm_config_db #(tb_config)::get(this,"","m_cfg",m_cfg))
	    `uvm_fatal("CONFIG","cannot get() env cfg from uvm_config_db. Have you set() it?")
    // LAB : Create dynamic array handles source and destination agent sequencers equal to
	// the config parameter no_of_source and destination agents
	src_agt_seqr = new[m_cfg.no_of_src_agents];
	dst_agt_seqr = new[m_cfg.no_of_dst_agents];

endfunction
