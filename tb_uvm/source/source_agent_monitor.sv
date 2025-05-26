
class source_agent_monitor extends uvm_monitor;

    //factory registration
    `uvm_component_utils(source_agent_monitor)
     source_xtn xtn;
uvm_analysis_port #(source_xtn) monitor_port;

source_agent_config m_cfg;
virtual router_if.SMON_MP vif;

    extern function new(string name = "source_agent_monitor",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
extern function void connect_phase(uvm_phase phase); 
extern task run_phase(uvm_phase phase);
extern task monitor();  
endclass

//constructor new method
function source_agent_monitor::new(string name = "source_agent_monitor",uvm_component parent);
    super.new(name,parent);
monitor_port = new("monitor_port",this);
endfunction

//build phase of source agent monitor
function void source_agent_monitor::build_phase(uvm_phase phase);
 super.build_phase(phase); 
if(!uvm_config_db #(source_agent_config) :: get(this,"","src_cfg",m_cfg))
		`uvm_fatal(get_type_name(),"getting is failed in monitor")
endfunction

function void source_agent_monitor::connect_phase(uvm_phase phase);
vif = m_cfg.vif;
endfunction

task source_agent_monitor::run_phase(uvm_phase phase);


forever begin 
monitor();
end
//end
endtask



task source_agent_monitor::monitor();

xtn = source_xtn :: type_id :: create("xtn");

while(vif.smon_cb.busy!==0)
@(vif.smon_cb);

while(vif.smon_cb.pkt_valid !==1)
@(vif.smon_cb);

xtn.header = vif.smon_cb.data_in;
xtn.payload = new[xtn.header[7:2]];
@(vif.smon_cb);

foreach(xtn.payload[i])
	begin
		while(vif.smon_cb.busy !==0)
			@(vif.smon_cb);
		xtn.payload[i] = vif.smon_cb.data_in;
		@(vif.smon_cb);
	end

xtn.parity = vif.smon_cb.data_in;

repeat(2) @(vif.smon_cb);

xtn.error = vif.smon_cb.error;

monitor_port.write(xtn);
`uvm_info(get_type_name(),$sformatf("from source monitor %s",xtn.sprint()),UVM_LOW)
//xtn.print();
//repeat(20) @(vif.smon_cb);

endtask
