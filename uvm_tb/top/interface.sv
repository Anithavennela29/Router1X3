interface router_if(input bit clock);


logic [7:0] data_in;

logic pkt_valid;
logic resetn;
logic busy;
logic error;
logic read_enb;
logic valid_out;
logic [7:0] data_out;

  
clocking sdrv_cb @(posedge clock);
default input #1 output #1;
output data_in,pkt_valid,resetn;
input busy;
endclocking


clocking smon_cb @(posedge clock);
default input #1 output #1;
input data_in, pkt_valid,resetn, busy, error;
endclocking

clocking ddrv_cb @(posedge clock);
default input #1 output #1;

output read_enb;
input valid_out;
endclocking


clocking dmon_cb @(posedge clock);
default input #1 output #1;
input read_enb,valid_out,data_out;
endclocking

  modport DDRV_MP(clocking ddrv_cb);
    modport DMON_MP(clocking dmon_cb);
  modport SDRV_MP(clocking sdrv_cb);
    modport SMON_MP(clocking smon_cb);
endinterface

