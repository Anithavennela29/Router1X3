// Extend ram_wr_agent from uvm_agent
class source_agent extends uvm_agent;

   // Factory Registration
	 `uvm_component_utils(source_agent)

	//Declare the source_driver handle

         source_agent_driver drvh;
source_agent_monitor monh;
source_agent_sequencer seqrh;
        source_agent_config src_cfg;
	//------------------------------------------
	// METHODS
	//------------------------------------------

	//Add all the UVM phases
	extern function new(string name = "source_agent",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
	extern function void connect_phase(uvm_phase phase);
	
endclass


//-----------------  constructor new method  -------------------//

function source_agent::new(string name = "source_agent", uvm_component parent);
    super.new(name, parent);
  endfunction

   
// Add UVM phases
// NOTE : Call super.*_phase() in every phase method ,* indicates build,connect,etc  
//        Print using `uvm_info("RAM_AGENT","This is build phase",UVM_LOW)  in all the phases 
    
//-----------------  Add UVM build() phase   -------------------//
// In build phase create the instance of driver 
function void source_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
    if(!uvm_config_db #(source_agent_config) :: get(this,"","src_cfg",src_cfg))
		`uvm_fatal(get_type_name(),"getting is failed in agent")

monh = source_agent_monitor::type_id::create("monh",this);
if(src_cfg.is_active == UVM_ACTIVE)
begin
	drvh = source_agent_driver :: type_id :: create("drvh",this);
	seqrh = source_agent_sequencer :: type_id :: create("seqrh",this);
end
 endfunction


//-----------------  Add UVM connect() phase   -------------------//
  
 function void source_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    `uvm_info("SOURCE_AGENT", "This is Connect Phase", UVM_LOW);
if(src_cfg.is_active == UVM_ACTIVE)
	drvh.seq_item_port.connect(seqrh.seq_item_export);
   endfunction


