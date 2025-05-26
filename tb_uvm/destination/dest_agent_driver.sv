
class dest_agent_driver extends uvm_driver#(dest_xtn);

    //factory registration
    `uvm_component_utils(dest_agent_driver)
   dest_agent_config m_cfg;
virtual router_if.DDRV_MP vif;


    extern function new(string name = "dest_agent_driver", uvm_component parent);
    extern function void build_phase(uvm_phase phase);
   extern function void connect_phase(uvm_phase phase);

   extern task run_phase(uvm_phase phase);
     extern task send_to_dut(dest_xtn xtn);


endclass

//constructor new method
function dest_agent_driver::new(string name = "dest_agent_driver", uvm_component parent);
    super.new(name,parent);
endfunction

//build phase of destination agent driver
function void dest_agent_driver::build_phase(uvm_phase phase);
    `uvm_info("INFO","This is the build phase of destination agent driver",UVM_LOW)
 if(!uvm_config_db #(dest_agent_config) :: get(this,"","dst_cfg",m_cfg))
		`uvm_fatal(get_type_name(),"getting is failed")
    super.build_phase(phase);
endfunction


function void dest_agent_driver::connect_phase(uvm_phase phase);
vif = m_cfg.vif;
endfunction

//task run_phase(uvm_phase phase);
task dest_agent_driver::run_phase(uvm_phase phase);

forever	begin
		seq_item_port.get_next_item(req);
		
		send_to_dut(req);
		
		seq_item_port.item_done();

	end
endtask

task dest_agent_driver::send_to_dut(dest_xtn xtn);

wait(vif.ddrv_cb.valid_out)

repeat(xtn.cycles)
@(vif.ddrv_cb);
vif.ddrv_cb.read_enb <= 1;

@(vif.ddrv_cb)
wait(vif.ddrv_cb.valid_out==0)

@(vif.ddrv_cb);
vif.ddrv_cb.read_enb <=0;

`uvm_info(get_type_name(),$sformatf("from destination driver %s",req.sprint()),UVM_LOW)

endtask

