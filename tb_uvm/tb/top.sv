module top();

import uvm_pkg::*;
import router_pkg::*;

//`include "router_assertions.sv"

bit clock;

always #5 clock = ~clock;

router_if src_if0(clock);
router_if dst_if0(clock);
router_if dst_if1(clock);
router_if dst_if2(clock);


router DUV(.clock(clock),
		.resetn(src_if0.resetn),
		.read_enb_0(dst_if0.read_enb),
		.read_enb_1(dst_if1.read_enb),
		.read_enb_2(dst_if2.read_enb),
		.pkt_valid(src_if0.pkt_valid),
		.data_in(src_if0.data_in),
		.data_out_0(dst_if0.data_out),
		.data_out_1(dst_if1.data_out),
		.data_out_2(dst_if2.data_out),
		.vld_out_0(dst_if0.valid_out),
		.vld_out_1(dst_if1.valid_out),
		.vld_out_2(dst_if2.valid_out),
		.err(src_if0.error),
		.busy(src_if0.busy));

/*bind router router_assertions bind_inst(
  .clock(clock),
  .pkt_valid(src_if0.pkt_valid),
  .busy(src_if0.busy),
  .data_in(src_if0.data_in)
);*/


initial 
begin
	
	
	`ifdef VCS
	$fsdbDumpvars(0, top);
	`endif
	
	uvm_config_db #(virtual router_if) :: set(null,"*","src_if0",src_if0);
	uvm_config_db #(virtual router_if) :: set(null,"*","dst_if0",dst_if0);
	uvm_config_db #(virtual router_if) :: set(null,"*","dst_if1",dst_if1);
	uvm_config_db #(virtual router_if) :: set(null,"*","dst_if2",dst_if2);
	
	//uvm_top.enable_print_topology = 1;
	
        run_test();
end


property pkt_valid_p;
  @(posedge clock) $rose(src_if0.pkt_valid) |=> src_if0.busy;
endproperty

 property busy_p;
  @(posedge clock) src_if0.busy |=> $stable(src_if0.data_in);
endproperty

     property read_enb0;
        @(posedge clock) (dst_if0.valid_out) |=> ##[1:29] (dst_if0.read_enb);
    endproperty 

    property read_enb1;
        @(posedge clock) (dst_if1.valid_out) |=> ##[1:29] (dst_if1.read_enb);
    endproperty 

    property read_enb2;
        @(posedge clock) (dst_if2.valid_out) |=> ##[1:29] (dst_if2.read_enb);
    endproperty 

// Assert the property in the code
A1:assert property (pkt_valid_p)else
  $error("Assertion failed: pkt_valid rose but busy was not asserted");


  A2:assert property (busy_p)  else
  $error("Assertion failed: busy asserted but data_in changed");



   /* A4 : assert property(read_enb0) else
         $display("Assertions is not successfull for read_enb0");

    A5 : assert property(read_enb1)else
          $display("Assertions is not successfull for read_enb1");

    A6 : assert property(read_enb2)  else
           $display("Assertions is not successfull for read_enb2");*/

endmodule


	