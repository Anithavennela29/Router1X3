

class router_env extends uvm_env;

    //Factory registration
    `uvm_component_utils(router_env)

    //handle for router source agent top and router destination agent top
    source_agent_top src_agt_toph;
    dest_agent_top dst_agt_toph;

    //handle for router scoreboard
    router_scoreboard scr_brd;
tb_config m_cfg;
    router_virtual_seqr v_seqr;

    extern function new(string name="router_env",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
     extern function void connect_phase(uvm_phase phase);
endclass

//constructor new method
function router_env::new(string name="router_env",uvm_component parent);
    super.new(name,parent);
endfunction

//build phase of router_env
function void router_env::build_phase(uvm_phase phase);
    super.build_phase(phase);
if(!uvm_config_db #(tb_config) :: get(this,"","m_cfg",m_cfg))
	`uvm_fatal(get_type_name(),"getting is failed")
    src_agt_toph = source_agent_top::type_id::create("src_agt_toph",this);
    dst_agt_toph = dest_agent_top::type_id::create("dst_agt_toph",this);
    scr_brd = router_scoreboard::type_id::create("scr_brd",this);
    v_seqr = router_virtual_seqr::type_id::create("v_seqr",this);
    `uvm_info("Router Env","This is build phase in Router Env",UVM_LOW)
endfunction

function void router_env::connect_phase(uvm_phase phase);

for(int i=0;i<m_cfg.no_of_src_agents;i++)
begin
		src_agt_toph.src_agt[i].monh.monitor_port.connect(scr_brd.fifo_srh[i].analysis_export);
		end
		
		for(int i=0;i<m_cfg.no_of_dst_agents;i++)
begin

			dst_agt_toph.dst_agt[i].dst_mon.monitor_port.connect(scr_brd.fifo_drh[i].analysis_export);
		end
	


foreach(v_seqr.dst_agt_seqr[i])
			v_seqr.dst_agt_seqr[i] =dst_agt_toph.dst_agt[i].dst_seqr;
foreach(v_seqr.src_agt_seqr[i])
			v_seqr.src_agt_seqr[i] = src_agt_toph.src_agt[i].seqrh;
endfunction
