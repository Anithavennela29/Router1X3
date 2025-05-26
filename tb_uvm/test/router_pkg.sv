
package router_pkg;

    //import uvm_pkg.sv
	import uvm_pkg::*;

    //include uvm_macros.sv
	`include "uvm_macros.svh"
    
    `include "source_xtn.sv"
    `include "dest_xtn.sv"

    `include "source_agent_config.sv"
    `include "dest_agent_config.sv"
    `include "tb_config.sv"

    `include "source_agent_driver.sv"
    `include "source_agent_monitor.sv"
    `include "source_agent_sequencer.sv"
    `include "source_agent.sv"
    `include "source_agent_top.sv"

    `include "dest_agent_driver.sv"
    `include "dest_agent_monitor.sv"
    `include "dest_agent_sequencer.sv"
    `include "dest_agent.sv"
    `include "dest_agent_top.sv"

    `include "router_virtual_seqr.sv"
    `include "router_scoreboard.sv"

    `include "router_env.sv"
     
     `include "source_agent_seqs.sv"
`include "dest_agent_seqs.sv"

`include "router_virtual_seqs.sv"
    `include "test.sv"
//`include "router_assertions.sv
endpackage