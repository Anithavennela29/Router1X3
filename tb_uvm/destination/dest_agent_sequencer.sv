
class dest_agent_sequencer extends uvm_sequencer#(dest_xtn);

    //factory registration
    `uvm_component_utils(dest_agent_sequencer)


    extern function new(string name="dest_agent_sequencer",uvm_component parent);

endclass

//constructor new method
function dest_agent_sequencer::new(string name="dest_agent_sequencer",uvm_component parent);
    super.new(name,parent);
endfunction
