class dest_agent_monitor extends uvm_monitor;

    // Factory registration
    `uvm_component_utils(dest_agent_monitor)

    // Analysis port for destination transaction
    uvm_analysis_port #(dest_xtn) monitor_port;
    
    // Transaction object to hold data
    dest_xtn xtn;
    
    // Configuration object for the monitor
    dest_agent_config m_cfg;
    
    // Virtual interface for the destination module
    virtual router_if.DMON_MP vif;

    // Constructor
    extern function new(string name="dest_agent_monitor", uvm_component parent);
    
    // Phase methods
    extern function void build_phase(uvm_phase phase);
    extern function void connect_phase(uvm_phase phase);
    extern task run_phase(uvm_phase phase);
    extern task monitor();
    
endclass

// Constructor method
function dest_agent_monitor::new(string name="dest_agent_monitor", uvm_component parent);
    super.new(name, parent);
    monitor_port = new("monitor_port", this);  // Create analysis port
endfunction

// Build phase: Initialize and check configurations
function void dest_agent_monitor::build_phase(uvm_phase phase);
    `uvm_info("INFO", "This is the build phase of destination agent monitor", UVM_LOW)
    
    if (!uvm_config_db#(dest_agent_config)::get(this, "", "dst_cfg", m_cfg))
        `uvm_fatal(get_type_name(), "Configuration fetching failed")
    
    super.build_phase(phase);  // Call parent's build_phase
endfunction

// Connect phase: Setup virtual interface
function void dest_agent_monitor::connect_phase(uvm_phase phase);
    vif = m_cfg.vif;  // Assign virtual interface
endfunction

// Run phase: Start monitoring in a forever loop
task dest_agent_monitor::run_phase(uvm_phase phase);
    forever begin
        monitor();  // Monitor the interface
    end
endtask

// Monitoring task: Captures data from the virtual interface
task dest_agent_monitor::monitor();
    xtn = dest_xtn::type_id::create("xtn");  // Create a new transaction object

    // Wait for valid data (check read_enb or valid_out)
    while (vif.dmon_cb.read_enb !== 1) 
        @(vif.dmon_cb);  // Wait until valid data is available

    // Debugging: Print the state of the interface before reading
   // `uvm_info(get_type_name(), $sformatf("Waiting for valid data. read_enb: %b, data_out: %b", vif.dmon_cb.read_enb, vif.dmon_cb.data_out), UVM_LOW);

    // Capture the header from the interface
    @(vif.dmon_cb);  // Wait for the next valid data signal
    xtn.header = vif.dmon_cb.data_out;  // Store header value

    // Debugging: Print the captured header
   // `uvm_info(get_type_name(), $sformatf("Captured header: %b", xtn.header), UVM_LOW);

    // Create payload array based on header size (header[7:2] gives length)
    xtn.payload = new[xtn.header[7:2]];

    // Capture the payload data
    @(vif.dmon_cb);  // Wait for the next valid data
    foreach (xtn.payload[i]) begin
        xtn.payload[i] = vif.dmon_cb.data_out;  // Store payload data
        @(vif.dmon_cb);  // Wait for next cycle
    end

    // Capture parity
    xtn.parity = vif.dmon_cb.data_out;

    // Debugging: Print the captured data
    //`uvm_info(get_type_name(), $sformatf("Captured parity: %b", xtn.parity), UVM_LOW);
    
    // Log the transaction data
    `uvm_info(get_type_name(), $sformatf("from destination monitor %s", xtn.sprint()), UVM_LOW)

    // Send the captured transaction to the analysis port
    monitor_port.write(xtn);
 repeat(10)@(vif.dmon_cb);
endtask
