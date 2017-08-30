`ifndef __REG_CPU_SCOREBOARD__
`define __REG_CPU_SCOREBOARD__

`include "reg_cpu_common.svh"


class reg_cpu_scoreboard#(int AW, int DW) extends uvm_scoreboard;

    // Analysis fifo is connected to the monitor.
    uvm_tlm_analysis_fifo #(reg_cpu_data#(AW, DW)) actual_data_af;
    //uvm_tlm_analysis_fifo #(u_data#(AW, DW)) exp_data_af;

    // This is the collected data.
    reg_cpu_data#(AW, DW) actual_data;
    reg_cpu_data#(AW, DW) exp_data;

    int num_compare;
    int num_compare_ok;

    // Associative Array
    typedef bit [AW-1:0] index_t;
    typedef bit [DW-1:0] data_t;
    data_t [DW-1:0] ooo_array[index_t];
    index_t keys[$];
    data_t rd_data;


    // Factory registration
    `uvm_component_param_utils(reg_cpu_scoreboard#(AW, DW))


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // We use new for analysis fifo which cannot be registered to UVM Factory.
        actual_data_af = new("actual_data_af", this);
        //exp_data_af = new("exp_data_af", this);

        actual_data = reg_cpu_data#(AW, DW)::type_id::create("actual_data");
        exp_data = reg_cpu_data#(AW, DW)::type_id::create("exp_data");

        `uvm_info(get_full_name(), "BUILD_PHASE done", UVM_LOW)
    endfunction : build_phase


    virtual task run_phase(uvm_phase phase);
        super.run_phase(phase);
        watcher();
    endtask: run_phase


    virtual function void report_phase(uvm_phase phase);
        `uvm_info(  get_name()
                    , $sformatf("REPORT: COMPARE_NUM=%4d"
                                , num_compare)
                    , UVM_LOW)
        `uvm_info(  get_name()
                    , $sformatf("REPORT: COMPARE_OK=%4d, COMPARE_NG=%4d"
                                , num_compare_ok
                                , num_compare-num_compare_ok)
                    , UVM_LOW)
    endfunction : report_phase


    //----- Local Function
    function void set_data(index_t addr, data_t data);
        `uvm_info(  get_name()
                    , $sformatf("[set_data] addr:0x%08x, data:0x%08x", addr, data)
                    , UVM_LOW)
        ooo_array[addr] = data;
    endfunction;

    function data_t get_data(index_t addr);
        data_t data_tmp = ooo_array[addr];
        `uvm_info(  get_name()
                    , $sformatf("[get_data] addr:0x%08x, data:0x%08x", addr, data_tmp)
                    , UVM_LOW)
        return data_tmp;
    endfunction;


    virtual task watcher();
        num_compare = 0;
        num_compare_ok = 0;
        rd_data = 0;
        forever begin
            // Wait for the arrival of actual_data
            actual_data_af.get(actual_data);

            if (actual_data.reg_cpu_we)
                set_data(actual_data.reg_cpu_addr, actual_data.reg_cpu_data_wr);
            else
            if (actual_data.reg_cpu_re) begin
                rd_data = get_data(actual_data.reg_cpu_addr);
                // Do compare after getting actual_data and exp_data.
                compare_data(actual_data.reg_cpu_addr, rd_data);
            end
        end
    endtask: watcher


    virtual task compare_data(index_t addr, data_t rd_data);
        data_t exp_data = get_data(addr);

        num_compare++;
        if (rd_data != exp_data)
            `uvm_error(
                get_name()
                , $sformatf("[COMPARE_ERROR] addr=0x%08x, actual=0x%08x, expected=0x%08x"
                , addr, rd_data, exp_data)
            )
        else
            num_compare_ok++;

    endtask: compare_data


endclass : reg_cpu_scoreboard

`endif
