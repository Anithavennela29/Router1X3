
class router_scoreboard extends uvm_scoreboard;

    `uvm_component_utils(router_scoreboard)
uvm_tlm_analysis_fifo #(source_xtn) fifo_srh[];
uvm_tlm_analysis_fifo #(dest_xtn) fifo_drh[];

tb_config m_cfg;
source_xtn s_xtn;
dest_xtn d_xtn;

//int recieved_data_count;
//int mismatched_data_count;
int verified_data_count;

    extern function new(string name = "router_scoreboard",uvm_component parent);
    extern function void build_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);

    extern function void check_data(dest_xtn xtn);
    extern function void report_phase(uvm_phase phase);


covergroup s_cov;
	PAYLOAD_LENGTH: coverpoint s_xtn.header[7:2]{
					bins small_payload={[1:17]};
					bins medium_payload={[18:34]};
					bins large_payload = {[35:63]};
						}
	ADDRESS : coverpoint s_xtn.header[1:0]{
					bins address[]={0,1,2};
					illegal_bins ILLB={3};
						}
	ERROR : coverpoint s_xtn.error;
endgroup

covergroup d_cov;
	
PAYLOAD_LENGTH: coverpoint d_xtn.header[7:2]{
					bins small_payload={[1:20]};
					bins medium_payload={[21:40]};
					bins large_payload = {[41:63]};
						}
ADDRESS : coverpoint d_xtn.header[1:0]{
					bins address[]={0,1,2};
					illegal_bins ILLB={3};
						}
endgroup


endclass 

//constructor new method
function router_scoreboard::new(string name = "router_scoreboard",uvm_component parent);
    super.new(name,parent);
s_cov = new;
d_cov = new;
endfunction

//build phase of router scoreboard
function void router_scoreboard::build_phase(uvm_phase phase);
    `uvm_info("INFO","This is the build phase of router scoreboard",UVM_LOW)
    super.build_phase(phase);
if(!uvm_config_db #(tb_config) :: get(this,"","m_cfg",m_cfg))
	`uvm_fatal(get_type_name(),"getting is failed")

fifo_srh = new[m_cfg.no_of_src_agents];

foreach(fifo_srh[i])
	fifo_srh[i] = new($sformatf("fifo_srh[%0d]",i),this);

fifo_drh = new[m_cfg.no_of_dst_agents];

foreach(fifo_drh[i])
	fifo_drh[i] = new($sformatf("fifo_drh[%0d]",i),this);

endfunction 

task router_scoreboard::run_phase(uvm_phase phase);
fork
     begin
         forever
		begin
		fifo_srh[0].get(s_xtn);
//s_cov=s_xtn;
		s_cov.sample();

                  end
        end
begin
       forever
           begin
               fork
                    begin
		//recieved_data_count ++;
		fifo_drh[0].get(d_xtn);
				check_data(d_xtn);
                   // d_cov=d_xtn;
                     d_cov.sample();
		end

  begin
		//recieved_data_count ++;
		fifo_drh[1].get(d_xtn);
				check_data(d_xtn);
                    //d_cov=d_xtn;
                     d_cov.sample();
		end


  begin
		//recieved_data_count ++;
		fifo_drh[2].get(d_xtn);
				check_data(d_xtn);
                    //d_cov=d_xtn;
                     d_cov.sample();
		end
            join_any
        disable fork;
end
end
join
endtask


function void router_scoreboard::check_data(dest_xtn xtn);
`uvm_info(get_type_name(),$sformatf("\n__________________________________________________________________________________________\n\nsource_monitor object %s \n destination monitor object %s \n\n ______________________________________________________",s_xtn.sprint(),d_xtn.sprint()),UVM_LOW)
if(s_xtn.header== xtn.header)
		`uvm_info(get_type_name(),"header matched",UVM_LOW)
else
       `uvm_error("sb","header mismatched")
					
if(s_xtn.payload == xtn.payload)
	`uvm_info(get_type_name(),"payload matched",UVM_LOW)
else
	`uvm_info(get_type_name(),"payload mismatched",UVM_LOW)

/*foreach(s_xtn.payload[i])
if(s_xtn.payload[i] !== xtn.payload[i])
	begin
		`uvm_info(get_type_name(),$sformatf("payload[%0d] is mismatched",i),UVM_LOW)
		mismatched_data_count++;
		return;
	end
*/

if(s_xtn.parity==xtn.parity)
	`uvm_info(get_type_name(),"parity matched",UVM_LOW)
else
       `uvm_error("sb","parity mismatched")
					

verified_data_count ++;
endfunction


function void router_scoreboard::report_phase(uvm_phase phase);
`uvm_info(get_type_name(),"scoreboard report_phase",UVM_LOW)
`uvm_info(get_type_name(),$sformatf(" \n verified_data_count - %0d ",verified_data_count),UVM_LOW)

endfunction
