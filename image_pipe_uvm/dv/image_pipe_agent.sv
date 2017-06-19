`ifndef __IMAGE_PIPE_AGENT__
    `define __IMAGE_PIPE_AGENT__

`include "common_header.svh"
`include "image_pipe_sequencer.sv"
`include "image_pipe_driver.sv"
`include "image_pipe_monitor.sv"


class image_pipe_agent extends uvm_agent;
    protected uvm_active_passive_enum is_active = UVM_ACTIVE;

    image_pipe_sequencer sequencer;
    image_pipe_driver driver;
    image_pipe_monitor monitor;

    `uvm_component_utils_begin(image_pipe_agent)
        `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_component_utils_end

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (is_active==UVM_ACTIVE) begin
            sequencer = image_pipe_sequencer::type_id::create("sequencer", this);
            driver = image_pipe_driver::type_id::create("driver", this);
        end

        monitor = image_pipe_monitor::type_id::create("monitor", this);

        `uvm_info(get_full_name( ), "Build stage compete.", UVM_LOW)
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        if (is_active == UVM_ACTIVE)
            driver.seq_item_port.connect(sequencer.seq_item_export);

        `uvm_info(get_full_name( ), "Connect stage complete.", UVM_LOW)
    endfunction : connect_phase

endclass : image_pipe_agent

`endif
