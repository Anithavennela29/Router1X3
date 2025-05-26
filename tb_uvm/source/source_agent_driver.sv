class source_agent_driver extends uvm_driver#(source_xtn);

   // Factory Registration
   	 `uvm_component_utils(source_agent_driver)
source_agent_config src_cfg;
virtual router_if.SDRV_MP vif;

	//------------------------------------------
	// METHODS
	//------------------------------------------

	// Add all the UVM phases:
	extern function new(string name = "source_agent_driver",uvm_component parent);
	extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);

	extern task run_phase(uvm_phase phase);
        extern task send_to_dut(source_xtn xtn);
endclass


//-----------------  constructor new method  -------------------//
//Add code for new()

function source_agent_driver::new(string name = "source_agent_driver", uvm_component parent);
    super.new(name, parent);
endfunction

//-----------------  Add UVM build() phase   -------------------//

    function void source_agent_driver::build_phase(uvm_phase phase);
 if(!uvm_config_db #(source_agent_config) :: get(this,"","src_cfg",src_cfg))
		`uvm_fatal(get_type_name(),"getting is failed")
super.build_phase(phase);
endfunction

function void source_agent_driver::connect_phase(uvm_phase phase);
vif = src_cfg.vif;
endfunction


task source_agent_driver::run_phase(uvm_phase phase);

	@(vif.sdrv_cb);
	vif.sdrv_cb.resetn <= 0;
	@(vif.sdrv_cb);
	vif.sdrv_cb.resetn <= 1;
forever begin

	seq_item_port.get_next_item(req);
`uvm_info(get_type_name(),$sformatf("from source driver %s",req.sprint()),UVM_LOW)
	send_to_dut(req);
//`uvm_info(get_type_name(),$sformatf("from source driver %s",req.sprint()),UVM_LOW)

	seq_item_port.item_done();
end
//end	


endtask

task source_agent_driver::send_to_dut(source_xtn xtn);

//xtn.print();

while (vif.sdrv_cb.busy != 0) 
  @(vif.sdrv_cb);
 
vif.sdrv_cb.pkt_valid <= 1;
vif.sdrv_cb.data_in <= xtn.header;

@(vif.sdrv_cb);//2nd cycle

foreach(xtn.payload[i])
	begin
		while(vif.sdrv_cb.busy != 0)
			@(vif.sdrv_cb);
	vif.sdrv_cb.data_in <= xtn.payload[i];
	@(vif.sdrv_cb);
	end

while(vif.sdrv_cb.busy !== 0)
	@(vif.sdrv_cb);

vif.sdrv_cb.data_in <= xtn.parity;
vif.sdrv_cb.pkt_valid <= 0;
//xtn.print();

repeat(5) @(vif.sdrv_cb);

endtask
