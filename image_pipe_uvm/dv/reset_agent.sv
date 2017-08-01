`ifndef __RESET_AGENT__
    `define __RESET_AGENT__

`include "common_header.svh"
`include "reset_sequencer.sv"
`include "reset_driver.sv"


class reset_agent extends uvm_agent;
    protected uvm_active_passive_enum is_active = UVM_ACTIVE;

    reset_sequencer sequencer;
    reset_driver driver;

    `uvm_component_param_utils_begin(reset_agent)
        `uvm_field_enum(uvm_active_passive_enum, is_active, UVM_ALL_ON)
    `uvm_component_utils_end

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (is_active==UVM_ACTIVE) begin
            sequencer = reset_sequencer::type_id::create("sequencer", this);
            driver = reset_driver::type_id::create("driver", this);
        end

        `uvm_info(get_full_name( ), "BUILD_PHASE done.", UVM_LOW)
    endfunction : build_phase

    function void connect_phase(uvm_phase phase);
        if (is_active == UVM_ACTIVE)
            driver.seq_item_port.connect(sequencer.seq_item_export);

        `uvm_info(get_full_name( ), "CONNECT_PHASE done.", UVM_LOW)
    endfunction : connect_phase

endclass : reset_agent

`endif
