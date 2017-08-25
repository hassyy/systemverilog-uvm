`ifndef __REG_CPU_SCOREBOARD__
`define __REG_CPU_SCOREBOARD__

`include "reg_cpu_common.svh"


class reg_cpu_scoreboard#(int AW, int DW) extends uvm_scoreboard;

    // Analysis fifo is connected to the monitor.
    uvm_tlm_analysis_fifo #(reg_cpu_data#(AW, DW)) af_in;
    uvm_tlm_analysis_fifo #(reg_cpu_data#(AW, DW)) af_out;

    // This is the collected data.
    reg_cpu_data#(AW, DW) in_data;
    reg_cpu_data#(AW, DW) out_data;

    int num_compare;
    int num_compare_ok;

    // Factory registration
    `uvm_component_param_utils(reg_cpu_scoreboard#(AW, DW))


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // We use new for analysis fifo which cannot be registered to UVM Factory.
        af_in= new("af_in", this);
        af_out= new("af_out", this);

        in_data = reg_cpu_data#(AW, DW)::type_id::create("in_data");
        out_data = reg_cpu_data#(AW, DW)::type_id::create("out_data");

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
            af_in.get(in_data);
            // Then wait for the arrival of in_data
            af_out.get(out_data);
            // Do compare after getting in_data and out_data.
            compare_data();
        end
    endtask: watcher


    virtual task compare_data();

        num_compare++;
        if (in_data.reg_cpu_data_in != out_data.ipm_data_out)
            `uvm_error(
                //get_type_name()
                get_name()
                , $sformatf("[COMPARE_ERROR] actual=%0h, expected=%0h"
                , out_data.ipm_data_out, in_data.reg_cpu_data_in)
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

endclass : reg_cpu_scoreboard

`endif
