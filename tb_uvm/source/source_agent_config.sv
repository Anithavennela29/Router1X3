class source_agent_config extends uvm_object;
//factory registration
`uvm_object_utils (source_agent_config)
//parameters
uvm_active_passive_enum is_active=UVM_ACTIVE;
virtual router_if vif;

extern function new(string name="source_agent_config");
endclass
//new constructor
function source_agent_config::new(string name ="source_agent_config");
super.new(name);
endfunction
