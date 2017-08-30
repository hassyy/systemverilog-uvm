`ifndef __REG_CPU_MONITOR__
`define __REG_CPU_MONITOR__


`include "reg_cpu_common.svh"

`ifndef _IF_NAME
`define _IF_NAME reg_cpu_if_name
`endif
`ifndef _TO_STRING
`define _TO_STRING(x) `"x`"
`endif

class reg_cpu_monitor #(int AW, int DW) extends uvm_monitor;

    virtual reg_cpu_if #(.AW(AW), .DW(DW)) vif;
    string `_IF_NAME;
    //int num_collected_data;


    uvm_analysis_port #(reg_cpu_data#(AW, DW)) ap;
    reg_cpu_data #(AW, DW) data_collected;
    reg_cpu_data #(AW, DW) data_clone;

    `uvm_component_param_utils(reg_cpu_monitor#(AW, DW))

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // This string is used to identify the vif set later.
        if (!uvm_config_db#(string)::get(this, "", `_TO_STRING(`_IF_NAME), `_IF_NAME))
            `uvm_fatal("NOSTRING", {"Need interface name for: ", get_full_name( ), `_TO_STRING(.`_IF_NAME)})

        uvm_report_info("", $sformatf("INTERFACE NAME: %0s", `_IF_NAME), UVM_LOW);

        // This set the vif with the string previously set.
        if (!uvm_config_db#(virtual reg_cpu_if#(.AW(AW), .DW(DW)))::get(this, "", `_IF_NAME, vif))
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name( ), ".vif"})

        // We need to instantiate analysys_port by new. It cannot be registerd to UVM Factory.
        ap = new("ap", this);
        data_collected = reg_cpu_data#(AW, DW)::type_id::create("data_collected");
        data_clone     = reg_cpu_data#(AW, DW)::type_id::create("data_clone");

        `uvm_info(get_full_name(), "BUILD_PHASE done", UVM_LOW)
    endfunction : build_phase


    // Main process of monitor
    virtual task run_phase(uvm_phase phase);
        collect_data( );
    endtask: run_phase


    virtual task collect_data( );
        forever begin
            // We must use clocking block for monitor to have proper data collect timing.

            wait(vif.cb_mon.reg_cpu_cs);
            data_collected.reg_cpu_addr = vif.cb_mon.reg_cpu_addr;
            data_collected.reg_cpu_we   = vif.cb_mon.reg_cpu_cs;
            data_collected.reg_cpu_we   = vif.cb_mon.reg_cpu_we;
            data_collected.reg_cpu_re   = vif.cb_mon.reg_cpu_re;

            if (vif.cb_mon.reg_cpu_we) begin
                data_collected.reg_cpu_data_wr = vif.cb_mon.reg_cpu_data_wr;
                wait(vif.cb_mon.reg_cpu_wack);
            end
            else
            if (vif.cb_mon.reg_cpu_re) begin
                wait(vif.cb_mon.reg_cpu_rdv);
                data_collected.reg_cpu_data_rd = vif.cb_mon.reg_cpu_data_rd;
            end

            data_collected.reg_cpu_wack = vif.cb_mon.reg_cpu_wack;
            data_collected.reg_cpu_rdv  = vif.cb_mon.reg_cpu_rdv;

            // We must clone the data to send it to analysis port.
            $cast(data_clone, data_collected.clone( ));
            ap.write(data_clone);

            //num_collected_data++;
            @(posedge vif.cb_mon);
        end
    endtask: collect_data


    virtual function void report_phase(uvm_phase phase);
/*
        `uvm_info(  get_type_name()
                    , $sformatf("REPORT: COLLECTED PACKETS = %0d", num_collected_data)
                    , UVM_LOW
                    )
*/
    endfunction : report_phase


endclass : reg_cpu_monitor

`ifdef _IF_NAME
`undef _IF_NAME
`endif
`ifdef _TO_STRING
`undef _TO_STRING
`endif

`endif
