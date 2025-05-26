class tb_config extends uvm_object;
`uvm_object_utils (tb_config)


    source_agent_config src_cfg[];
    dest_agent_config dst_cfg[];

    //declaring no of source and destination agents
    int no_of_src_agents;
    int no_of_dst_agents;
 extern function new(string name="tb_config");

endclass

function tb_config::new(string name="tb_config");
super.new(name);
endfunction

