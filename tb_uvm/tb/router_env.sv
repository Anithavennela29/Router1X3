

class router_env extends uvm_env;

    //Factory registration
    `uvm_component_utils(router_env)

    //handle for router source agent top and router destination agent top
    source_agent_top src_agt_toph;
    dest_agent_top dst_agt_toph;

    //handle for router scoreboard
    router_scoreboard scr_brd;

    router_virtual_seqr v_seqr;

    extern function new(string name="router_env",uvm_component parent);
    extern function void build_phase(uvm_phase phase);

endclass

//constructor new method
function router_env::new(string name="router_env",uvm_component parent);
    super.new(name,parent);
endfunction

//build phase of router_env
function void router_env::build_phase(uvm_phase phase);
    super.build_phase(phase);
    src_agt_toph = source_agent_top::type_id::create("src_agt_toph",this);
    dst_agt_toph = dest_agent_top::type_id::create("dst_agt_toph",this);
    scr_brd = router_scoreboard::type_id::create("scr_brd",this);
    v_seqr = router_virtual_seqr::type_id::create("v_seqr",this);
    `uvm_info("Router Env","This is build phase in Router Env",UVM_LOW)
endfunction
