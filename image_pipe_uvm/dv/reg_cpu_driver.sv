`ifndef __REG_CPU_DRIVER__
    `define __REG_CPU_DRIVER__

`include "common_header.svh"
`include "define.svh"
`include "reg_cpu_data.sv"

class reg_cpu_driver extends uvm_driver #(reg_cpu_data#());

    `uvm_component_param_utils(reg_cpu_driver)

    // Declare vif to drive signals
    virtual reg_cpu_if vif;


    // Mandatory
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new


    // Mandatory
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual reg_cpu_if)::get(this, "", "mst_intf", vif))
            `uvm_fatal("NOVIF", {get_full_name(), ".vif"})
    endfunction: build_phase


    // Main sequence (wrapper)
    virtual task run_phase(uvm_phase phase);
        fork
            reset();
            get_and_drive();
        join
    endtask: run_phase


    // sequence implementation
    virtual task reset();
        forever begin
            vif.cb_tb.reg_cpu_cs      <= '0;
            vif.cb_tb.reg_cpu_addr    <= '0;
            vif.cb_tb.reg_cpu_wr_data <= '0;
            vif.cb_tb.reg_cpu_we      <= '0;
            vif.cb_tb.reg_cpu_re      <= '0;
            @(negedge vif.rst_n);
        end
    endtask: reset


    virtual task get_and_drive();
        forever begin
            @(posedge vif.rst_n);
            while (vif.rst_n != `RESET_ACTIVE) begin
                seq_item_port.get_next_item(req);
                drive_sig(req);
                seq_item_port.item_done();
            end
        end
    endtask: get_and_drive


    virtual task drive_sig(reg_cpu_data#() req);

        // Wait during reset
        @(posedge vif.cb_tb iff(vif.rst_n != `RESET_ACTIVE));

        // Decode cmd_type
        case (req.reg_cpu_cmd)
            reg_cpu_data#()::WRITE: drive_write(req);
            reg_cpu_data#()::READ:  drive_read(req);
        endcase

        repeat(req.cmd_interval) @(posedge vif.cb_tb);

    endtask: drive_sig


    virtual task drive_sig_write(reg_cpu_data#() req);

        // [step1] Assert cs, addr, we
        vif.cb_tb.reg_cpu_cs   <= 1'b1;
        vif.cb_tb.reg_cpu_addr <= req.reg_cpu_addr;
        vif.cb_tb.reg_cpu_we   <= 1'b1;

        // [step2] Wait for wack.
        @(posedge vif.cb_tb.reg_cpu_wack);

        // [step3] Negate cs, addr, we
        vif.cb_tb.reg_cpu_cs   <= '0;
        vif.cb_tb.reg_cpu_addr <= '0;
        vif.cb_tb.reg_cpu_we   <= '0;
        @(posedge vif.cb_tb);

    endtask: drive_sig_write


    virtual task drive_sig_read(reg_cpu_data#() req);

        // [step1] Assert cs, addr, re
        vif.cb_tb.reg_cpu_cs   <= 1'b1;
        vif.cb_tb.reg_cpu_addr <= req.reg_cpu_addr;
        vif.cb_tb.reg_cpu_re   <= 1'b1;

        // [step2] Wait for rdv.
        @(posedge vif.cb_tb.reg_cpu_rdv);

        // [step3] Get read_data, negate cs, addr, re
        req.reg_cpu_rd_data <= vif.cb_tb.reg_cpu_cs;
        vif.cb_tb.reg_cpu_cs   <= '0;
        vif.cb_tb.reg_cpu_addr <= '0;
        vif.cb_tb.reg_cpu_re   <= '0;
        @(posedge vif.cb_tb);

    endtask: drive_sig_read






endclass: reg_cpu_driver

`endif