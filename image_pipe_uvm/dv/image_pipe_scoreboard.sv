`ifndef __IMAGE_PIPE_SCOREBOARD__
    `define __IMAGE_PIPE_SCOREBOARD__

`include "common_header.svh"
`include "image_pipe_data.sv"


class image_pipe_scoreboard extends uvm_scoreboard;
    localparam DW_IN=32;
    localparam DW_OUT=32;
    uvm_tlm_analysis_fifo #(image_pipe_data#(DW_IN, DW_OUT)) input_data_collected;
    uvm_tlm_analysis_fifo #(image_pipe_data#(DW_IN, DW_OUT)) output_data_collected;

    image_pipe_data#(DW_IN, DW_OUT) input_data;
    image_pipe_data#(DW_IN, DW_OUT) output_data;

    `uvm_component_utils(image_pipe_scoreboard)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        input_data_collected = new("input_data_collected", this);
        output_data_collected = new("output_data_collected", this);

        input_data = image_pipe_data#(DW_IN, DW_OUT)::type_id::create("input_data");
        output_data = image_pipe_data#(DW_IN, DW_OUT)::type_id::create("output_data");

        `uvm_info(get_full_name(), "Build stage complete.", UVM_LOW)

    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        watcher();
    endtask: run_phase

    virtual task watcher();
        forever begin
            input_data_collected.get(input_data);
            output_data_collected.get(output_data);
            compare_data();
        end
    endtask: watcher

    virtual task compare_data();
        bit [15:0] exp_data0;

        // input_data is already expected data.
        exp_data0 = input_data.is_data_in;

        if (exp_data0 != output_data.im_data_out)
            `uvm_error(
                get_type_name()
                , $sformatf("[COMPARE_ERROR] actual=%0h, expected=%0h"
                , output_data.im_data_out, exp_data0)
            )

    endtask: compare_data

endclass : image_pipe_scoreboard

`endif
