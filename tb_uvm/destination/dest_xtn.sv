class dest_xtn extends uvm_sequence_item;
    `uvm_object_utils(dest_xtn)

    bit [7:0] header;
    bit [7:0] payload[];
    bit [7:0] parity;
rand bit [5:0] cycles;
       

extern function void post_randomize();
extern function void do_print(uvm_printer printer);
extern function new(string name = "dest_xtn");
endclass

function dest_xtn::new(string name = "dest_xtn");
        super.new(name);
    endfunction

    // Print function
    function void dest_xtn::do_print(uvm_printer printer);
        printer.print_field("header", this.header, 8, UVM_BIN);
        foreach (payload[i]) begin
            printer.print_field($sformatf("payload[%0d]", i), this.payload[i], 8, UVM_BIN);
        end
        printer.print_field("parity", this.parity, 8, UVM_BIN);
       
        printer.print_field("cycles", this.cycles, 6, UVM_BIN);
    endfunction

function void dest_xtn::post_randomize();
        parity = header;
        foreach (payload[i]) begin
            parity ^= payload[i];
        end
    endfunction
