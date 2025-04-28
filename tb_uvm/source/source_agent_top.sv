class source_agent_top extends uvm_agent;

`uvm_component_utils(source_agent_top)

tb_config m_cfg;

source_agent src_agt[];

source_agent_config src_cfg;

extern function new(string name="source_agent_top",uvm_component parent);
extern function void build_phase(uvm_phase phase);

endclass

function source_agent_top::new(string name="source_agent_top",uvm_component parent);
super.new(name,parent);
endfunction

function void source_agent_top::build_phase(uvm_phase phase);

if(!uvm_config_db #(tb_config) :: get(this,"","m_cfg",m_cfg))
	`uvm_fatal(get_type_name(),"getting is failed")

src_agt = new[m_cfg.no_of_src_agents];

foreach(src_agt[i])
        begin
            src_agt[i] = source_agent::type_id::create($sformatf("src_agt[%0d]",i),this);

	uvm_config_db#(source_agent_config) ::set(this,$sformatf("src_agt[%0d]*",i),"src_cfg",m_cfg.src_cfg[i]);
end

endfunction

