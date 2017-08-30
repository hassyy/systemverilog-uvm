`ifndef __REG_CPU_DRIVER__
    `define __REG_CPU_DRIVER__

`include "reg_cpu_common.svh"


// FYI) uvm_driver #(REQ, RESP=REQ)
class reg_cpu_driver#(int AW, int DW) extends uvm_driver #(reg_cpu_data#(AW, DW));

    `uvm_component_param_utils(reg_cpu_driver#(AW, DW))

    // Declare vif to drive signals
    virtual reg_cpu_if#(.AW(AW), .DW(DW)) vif;
    string reg_cpu_if_name;


    // Mandatory
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new


    // Mandatory
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Register mst_if_name in config_db as string
        if (!uvm_config_db#(string)::get(this, "", "reg_cpu_if_name", reg_cpu_if_name))
            `uvm_fatal("NO_IF_NAME", {"Need interface name for: ", get_full_name( ), ".reg_cpu_if_name"})

        uvm_report_info("", $sformatf("INTERFACE NAME: %0s", reg_cpu_if_name), UVM_LOW);
        print_config();

        // Register reg_cpu_if specified by mst_if_name in config_db
        if (!uvm_config_db#(virtual reg_cpu_if#(.AW(AW), .DW(DW)))::get(this, "", reg_cpu_if_name, vif))
            `uvm_fatal("NO_VIF", {get_full_name(), ".vif"})
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
            vif.cb_tb.reg_cpu_data_wr <= '0;
            vif.cb_tb.reg_cpu_we      <= '0;
            vif.cb_tb.reg_cpu_re      <= '0;
            @(negedge vif.rst_n);
        end
    endtask: reset


            // FYI) "req" is declared in uvm_driver.
    // Use only "req" for both get_next_item() and item_done()
    // I dont know how to use rsp for item_done()...
    virtual task get_and_drive();
        forever begin
            @(posedge vif.rst_n);
            while (vif.rst_n != `REG_CPU_RESET_ACTIVE) begin
                seq_item_port.get_next_item(req);
                drive_sig();
                seq_item_port.item_done(req);
            end
        end
    endtask: get_and_drive


    virtual task drive_sig();

        // Wait during reset
        @(posedge vif.cb_tb iff(vif.rst_n != `REG_CPU_RESET_ACTIVE));

        if (req.first_flag)
            repeat(req.wait_before_start) @(posedge vif.cb_tb);

        // Decode cmd_type
        case (req.reg_cpu_cmd)
            reg_cpu_data#(AW, DW)::WRITE: write();
            reg_cpu_data#(AW, DW)::READ:  read();
        endcase

        repeat(req.cmd_interval) @(posedge vif.cb_tb);

    endtask: drive_sig


    virtual task write();

        // [step1] Assert cs, addr, we
        vif.cb_tb.reg_cpu_cs      <= 1'b1;
        vif.cb_tb.reg_cpu_we      <= 1'b1;
        vif.cb_tb.reg_cpu_addr    <= req.reg_cpu_addr;
        vif.cb_tb.reg_cpu_data_wr <= req.reg_cpu_data_wr;

        // [step2] Wait for wack.
        @(posedge vif.cb_tb.reg_cpu_wack);

        // [step3] Negate cs, addr, we
        vif.cb_tb.reg_cpu_cs      <= '0;
        vif.cb_tb.reg_cpu_we      <= '0;
        vif.cb_tb.reg_cpu_addr    <= '0;
        vif.cb_tb.reg_cpu_data_wr <= '0;
        @(posedge vif.cb_tb);

    endtask: write


    virtual task read();

        // [step1] Assert cs, addr, re
        vif.cb_tb.reg_cpu_cs   <= 1'b1;
        vif.cb_tb.reg_cpu_re   <= 1'b1;
        vif.cb_tb.reg_cpu_addr <= req.reg_cpu_addr;

        // [step2] Wait for rdv.
        @(posedge vif.cb_tb.reg_cpu_rdv);

        // [step3] Get read_data, negate cs, addr, re
        // Use req for returning value to item_done() just for convention.
        vif.cb_tb.reg_cpu_cs   <= '0;
        vif.cb_tb.reg_cpu_addr <= '0;
        vif.cb_tb.reg_cpu_re   <= '0;

        // Set retuen value for sequencer.
        req.reg_cpu_data_rd = vif.cb_tb.reg_cpu_data_rd;
        @(posedge vif.cb_tb);

    endtask: read

endclass: reg_cpu_driver

`endif
