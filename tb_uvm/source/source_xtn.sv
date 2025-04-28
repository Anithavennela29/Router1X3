class source_xtn extends uvm_sequence_item;
    `uvm_object_utils(source_xtn)

    rand bit [7:0] header;
    rand bit [7:0] payload[];
    rand bit [7:0] parity;
    bit error;

    

    // Constraints
    constraint head { header[1:0] != 3; header[7:2] != 0; }
    constraint pay_len { payload.size == header[7:2]; }
extern function new(string name="source_xtn");
extern function void post_randomize();
extern function void do_print(uvm_printer printer);
endclass

// Constructor
    function source_xtn::new(string name="source_xtn");
        super.new(name);
    endfunction

    // Post-randomization function
    function void source_xtn::post_randomize();
        // Use the external calculate_parity function to set parity
        parity = 0^header;
        foreach(payload[i])
           begin
            parity=payload[i]^header;
              end

    endfunction 


    // Print function
    function void source_xtn::do_print(uvm_printer printer);
        printer.print_field("header",this.header, 8, UVM_BIN);
        foreach (payload[i]) begin
            printer.print_field($sformatf("payload[%0d]", i), this.payload[i], 8, UVM_BIN);
        end
        printer.print_field("parity", this.parity, 8, UVM_BIN);
        printer.print_field("error", this.error, 1, UVM_DEC);
    endfunction


