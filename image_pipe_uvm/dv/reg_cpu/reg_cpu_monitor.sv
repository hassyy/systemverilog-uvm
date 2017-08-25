`ifndef __REG_CPU_MONITOR__
`define __REG_CPU_MONITOR__


`include "reg_cpu_common.svh"


class reg_cpu_monitor #(int AW, int DW) extends uvm_monitor;

    virtual reg_cpu_if #(.AW(AW), .DW(DW)) vif;
    string monitor_intf;
    //int num_collected_data;

    // This will be connected to scoreboard
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
        if (!uvm_config_db#(string)::get(this, "", "monitor_intf", monitor_intf))
            `uvm_fatal("NOSTRING", {"Need interface name for: ", get_full_name( ), ".monitor_intf"})

        `uvm_info(get_type_name( ), $sformatf("INTERFACE USED = %0s", monitor_intf), UVM_LOW)

        // This set the vif with the string previously set.
        if (!uvm_config_db#(virtual reg_cpu_if#(.AW(AW), .DW(DW)))::get(this, "", monitor_intf, vif))
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
            data_collected.reg_cpu_addr    = vif.cb_mon.reg_cpu_addr;
            if (vif.cb_mon.reg_cpu_we) begin
                data_collected.reg_cpu_data_wr = vif.cb_mon.reg_cpu_data_wr;
                wait(vif.cb_mon.reg_cpu_wack);
            end
            else
            if (vif.cb_mon.reg_cpu_re) begin
                wait(vif.cb_mon.reg_cpu_rdv);
                data_collected.reg_cpu_data_rd = vif.cb_mon.reg_cpu_data_rd;
            end

            // We must clone the data to send it to analysis port.
            $cast(data_clone, data_collected.clone( ));

            // Send the collected data on analisys port (to scoreboard)
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

`endif
