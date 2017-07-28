`ifndef __IMAGE_PIPE_AGENT__
    `define __IMAGE_PIPE_AGENT__

`include "common_header.svh"
`include "image_pipe_sequencer.sv"
`include "image_pipe_driver.sv"
`include "image_pipe_busy_driver.sv"
`include "image_pipe_busy_sequencer.sv"
`include "image_pipe_monitor.sv"


class image_pipe_agent #(int DW_IN=32, int DW_OUT=32) extends uvm_agent;
    protected uvm_active_passive_enum is_active = UVM_ACTIVE;
    protected uvm_active_passive_enum is_busy_active = UVM_ACTIVE;

    image_pipe_sequencer#(DW_IN, DW_OUT) sequencer;
    image_pipe_driver#(DW_IN, DW_OUT) driver;

    image_pipe_busy_sequencer#(DW_IN, DW_OUT) busy_sequencer;
    image_pipe_busy_driver busy_driver;

    image_pipe_monitor#(DW_IN, DW_OUT) monitor;

    //`uvm_component_param_utils_begin(image_pipe_agent#(DW_IN, DW_OUT))
    `uvm_component_param_utils_begin(image_pipe_agent)
        `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
        `uvm_field_enum(uvm_active_passive_enum, is_busy_active, UVM_ALL_ON)
    `uvm_component_utils_end

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (is_active==UVM_ACTIVE) begin
            sequencer = image_pipe_sequencer#(DW_IN, DW_OUT)::type_id::create("sequencer", this);
            driver = image_pipe_driver#(DW_IN, DW_OUT)::type_id::create("driver", this);
        end
        if (is_busy_active==UVM_ACTIVE) begin
            // Use defualt parameter. No specify DW_IN, DW_OUT
            busy_sequencer = image_pipe_busy_sequencer#(DW_IN, DW_OUT)::type_id::create("busy_sequencer", this);
            busy_driver = image_pipe_busy_driver::type_id::create("busy_driver", this);
        end

        monitor = image_pipe_monitor#(DW_IN, DW_OUT)::type_id::create("monitor", this);

        `uvm_info(get_full_name( ), "Build stage complete.", UVM_LOW)
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        if (is_active == UVM_ACTIVE)
            driver.seq_item_port.connect(sequencer.seq_item_export);
        if (is_busy_active == UVM_ACTIVE)
            busy_driver.seq_item_port.connect(busy_sequencer.seq_item_export);

        `uvm_info(get_full_name( ), "Connect stage complete.", UVM_LOW)
    endfunction : connect_phase

endclass : image_pipe_agent

`endif
