`ifndef __IMAGE_PIPE_SCOREBOARD__
    `define __IMAGE_PIPE_SCOREBOARD__

`include "image_pipe_data.sv"


class image_pipe_scoreboard#(int DW_IN=32, int DW_OUT=32) extends uvm_scoreboard;

    // Analysis fifo is connected to the monitor.
    uvm_tlm_analysis_fifo #(image_pipe_data#(DW_IN, DW_OUT)) in_data_af;
    uvm_tlm_analysis_fifo #(image_pipe_data#(DW_IN, DW_OUT)) out_data_af;

    // This is the collected data.
    image_pipe_data#(DW_IN, DW_OUT) in_data;
    image_pipe_data#(DW_IN, DW_OUT) out_data;

    int num_compare;
    int num_compare_ok;

    // Factory registration
    `uvm_component_utils(image_pipe_scoreboard#(DW_IN, DW_OUT))


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // We use new for analysis fifo which cannot be registered to UVM Factory.
        in_data_af = new("in_data_af", this);
        out_data_af = new("out_data_af", this);

        in_data = image_pipe_data#(DW_IN, DW_OUT)::type_id::create("in_data");
        out_data = image_pipe_data#(DW_IN, DW_OUT)::type_id::create("out_data");

        `uvm_info(get_full_name(), "BUILD_PHASE done", UVM_LOW)

    endfunction : build_phase


    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        watcher();
    endtask: run_phase


    virtual task watcher();
        num_compare = 0;
        num_compare_ok = 0;
        forever begin
            // Wait for the arrival of in_data
            in_data_af.get(in_data);
            // Then wait for the arrival of in_data
            out_data_af.get(out_data);
            // Do compare after getting in_data and out_data.
            compare_data();
        end
    endtask: watcher


    virtual task compare_data();

        num_compare++;
        if (in_data.is_data_in != out_data.im_data_out)
            `uvm_error(
                //get_type_name()
                get_name()
                , $sformatf("[COMPARE_ERROR] actual=%0h, expected=%0h"
                , out_data.im_data_out, in_data.is_data_in)
            )
        else
            num_compare_ok++;

    endtask: compare_data

    virtual function void report_phase(uvm_phase phase);
        `uvm_info(  get_type_name()
                    , $sformatf("REPORT: COMPARE_NUM=%4d"
                                , num_compare)
                    , UVM_LOW)
        `uvm_info(  get_type_name()
                    , $sformatf("REPORT: COMPARE_OK=%4d, COMPARE_NG=%4d"
                                , num_compare_ok
                                , num_compare-num_compare_ok)
                    , UVM_LOW)
    endfunction : report_phase

endclass : image_pipe_scoreboard

`endif
