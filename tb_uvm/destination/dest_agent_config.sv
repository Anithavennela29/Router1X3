
class dest_agent_config extends uvm_object;

    //factory registration
    `uvm_object_utils(dest_agent_config)

    //virtual interface handle
    virtual router_if vif;

    // Declare parameter is_active of type uvm_active_passive_enum and assign it to UVM_ACTIVE
    uvm_active_passive_enum is_active = UVM_ACTIVE;

    extern function new(string name="dest_agent_config");
endclass

//new constructor method
function dest_agent_config::new(string name="dest_agent_config");
    super.new(name);
endfunction