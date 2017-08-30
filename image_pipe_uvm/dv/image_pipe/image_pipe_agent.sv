`ifndef __IMAGE_PIPE_AGENT__
`define __IMAGE_PIPE_AGENT__

`include "image_pipe_common.svh"


class image_pipe_agent #(int DW_IN, int DW_OUT) extends uvm_agent;

    // Flag to use driver (msater side)
    protected uvm_active_passive_enum is_active = UVM_ACTIVE;
    // Flag to use busy_driver(slave side)
    protected uvm_active_passive_enum image_pipe_busy_active = UVM_ACTIVE;

    // MASTER side driver/seqr
    image_pipe_driver#(DW_IN, DW_OUT) driver;
    image_pipe_sequencer#(DW_IN, DW_OUT) sequencer;

    // SLAVE side driver/seqr
    image_pipe_busy_driver#(DW_IN, DW_OUT) busy_driver;
    image_pipe_busy_sequencer#(DW_IN, DW_OUT) busy_sequencer;

    // Monitor is used in both MASTER/SLAVE side (No flag)
    image_pipe_monitor#(DW_IN, DW_OUT) monitor;

    `uvm_component_param_utils(image_pipe_agent#(DW_IN, DW_OUT))
    // This MACRO will let flags be used vie config_db.
    // `uvm_component_param_utils_begin(image_pipe_agent#(DW_IN, DW_OUT))
        // `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
        // `uvm_field_enum(uvm_active_passive_enum, image_pipe_busy_active, UVM_ALL_ON)
       // uvm_active_passive_enum is_active = UVM_ACTIVE;
       // uvm_active_passive_enum image_pipe_busy_active = UVM_PASSIVE;
    // `uvm_component_utils_end


    // Mandatory.
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new


    // Mandatory. Instantiation
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // MASTER side build
        if (is_active==UVM_ACTIVE) begin
            driver    = image_pipe_driver#(DW_IN, DW_OUT)::type_id::create("driver", this);
            sequencer = image_pipe_sequencer#(DW_IN, DW_OUT)::type_id::create("sequencer", this);
        end

        // SLAVE side build
        if (image_pipe_busy_active==UVM_ACTIVE) begin
            busy_driver    = image_pipe_busy_driver#(DW_IN, DW_OUT)::type_id::create("busy_driver", this);
            busy_sequencer = image_pipe_busy_sequencer#(DW_IN, DW_OUT)::type_id::create("busy_sequencer", this);
        end

        monitor = image_pipe_monitor#(DW_IN, DW_OUT)::type_id::create("monitor", this);

        `uvm_info(get_full_name( ), "BUILD_PHASE done.", UVM_LOW)
    endfunction : build_phase


    // Mandatory. Connect driver and sequencer.
    // Note. monitor will be connected to scoreboard in ENV where scoreboard is instantiated.
    function void connect_phase(uvm_phase phase);
        // MASTER side
        if (is_active == UVM_ACTIVE)
            driver.seq_item_port.connect(sequencer.seq_item_export);

        // SLAVE side
        if (image_pipe_busy_active == UVM_ACTIVE)
            busy_driver.seq_item_port.connect(busy_sequencer.seq_item_export);

        `uvm_info(get_full_name( ), "CONNECT_PHASE done.", UVM_LOW)
    endfunction : connect_phase

endclass : image_pipe_agent

`endif
