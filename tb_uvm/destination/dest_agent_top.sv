
class dest_agent_top extends uvm_agent;

    `uvm_component_utils(dest_agent_top)

      dest_agent dst_agt[];

    //env config contains information about how many agents
    tb_config m_cfg;

    //destination agent config handle
    dest_agent_config dst_cfg;

    extern function new(string name="dest_agent_top",uvm_component parent);
    extern function void build_phase(uvm_phase phase);

endclass



function dest_agent_top::new(string name="dest_agent_top",uvm_component parent);
    super.new(name,parent);
endfunction


function void dest_agent_top::build_phase(uvm_phase phase);
    
    `uvm_info("INFO","This is the build phase of destination agent top",UVM_LOW)
    //get the env config 
    if(!uvm_config_db #(tb_config)::get(this,"","m_cfg",m_cfg))
        `uvm_fatal("CONFIG","Cannot get the env config. Have you set it?")
    
    //fixing the no of destination agents
    dst_agt = new[m_cfg.no_of_dst_agents];

    //creating memory for all the destination agents
    foreach(dst_agt[i])
        begin
            dst_agt[i] = dest_agent::type_id::create($sformatf("dst_agt[%0d]",i),this);
            
            uvm_config_db #(dest_agent_config)::set(this,$sformatf("dst_agt[%0d]*",i),"dst_cfg",m_cfg.dst_cfg[i]);
        end
    
endfunction
