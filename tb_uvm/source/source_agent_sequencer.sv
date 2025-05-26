class source_agent_sequencer extends uvm_sequencer #(source_xtn);

`uvm_component_utils(source_agent_sequencer)

function new(string name = "source_agent_sequencer",uvm_component parent);
super.new(name,parent);
endfunction

endclass