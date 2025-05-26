
class dest_agent extends uvm_agent;
    `uvm_component_utils(dest_agent)

    //destination driver handle
    dest_agent_driver dst_drv;

        dest_agent_sequencer dst_seqr;

       dest_agent_monitor dst_mon;

        dest_agent_config dst_cfg;

    extern function new(string name = "dest_agent",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
   extern function void connect_phase(uvm_phase phase);

endclass

//constructor new method
function dest_agent::new(string name = "dest_agent",uvm_component parent);
    super.new(name,parent);
endfunction


function void dest_agent::build_phase(uvm_phase phase);

    `uvm_info("INFO","This is the build phase of destination agent",UVM_LOW)
    

    if(!uvm_config_db #(dest_agent_config)::get(this,"","dst_cfg",dst_cfg))
        `uvm_fatal("CONFIG","Cannot ge the destination agent config. Have you set it?")
  
    dst_mon = dest_agent_monitor::type_id::create("dst_mon",this);

    if(dst_cfg.is_active == UVM_ACTIVE)
        begin
            dst_drv = dest_agent_driver::type_id::create("dst_drv",this);
            dst_seqr = dest_agent_sequencer::type_id::create("dst_seqr",this);
        end
    super.build_phase(phase);

endfunction

function void dest_agent::connect_phase(uvm_phase phase);
if(dst_cfg.is_active == UVM_ACTIVE)
	dst_drv .seq_item_port.connect(dst_seqr.seq_item_export);
endfunction