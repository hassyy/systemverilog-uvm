`ifndef __RESET_DRIVER__
    `define __RESET_DRIVER__

`include "reset_common.svh"
`include "reset_transaction.sv"

// FYI) uvm_driver #(REQ, RESP=REQ)
class reset_driver extends uvm_driver #(reset_transaction);

    `uvm_component_utils(reset_driver)

    // Declare vif to drive signals
    virtual reset_if reset_vif;

    // Mandatory
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new


    // Mandatory
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual reset_if)::get(this, "", "reset_if", reset_vif))
            `uvm_fatal("NOVIF", {get_full_name(), ".vif"})
    endfunction: build_phase


    // We use pre_reset/reset/post_reset_phase for reset_driver
    task pre_reset_phase(uvm_phase phase);
        `uvm_info(get_name(), "PRE_RESET_PHASE() STARTED", UVM_LOW)
        phase.raise_objection(this);

        seq_item_port.get_next_item(req);
        drive_sig();
        repeat(req.wait_before_reset) @reset_vif.cb_tb;
        seq_item_port.item_done();

        phase.drop_objection(this);
        `uvm_info(get_name(), "PRE_RESET_PHASE() DONE", UVM_LOW)
    endtask: pre_reset_phase


    task reset_phase(uvm_phase phase);
        `uvm_info(get_name(), "RESET_PHASE() STARTED", UVM_LOW)
        phase.raise_objection(this);

        seq_item_port.get_next_item(req);
        drive_sig();
        repeat(req.reset_cycle) @reset_vif.cb_tb;
        seq_item_port.item_done();

        phase.drop_objection(this);
        `uvm_info(get_name(), "RESET_PHASE() DONE", UVM_LOW)
    endtask: reset_phase


    task post_reset_phase(uvm_phase phase);
        `uvm_info(get_name(), "POST_RESET_PHASE() STARTED", UVM_LOW)
        phase.raise_objection(this);

        seq_item_port.get_next_item(req);
        drive_sig();
        @reset_vif.cb_tb;
        seq_item_port.item_done();

        phase.drop_objection(this);
        `uvm_info(get_name(), "RESET_PHASE() DONE", UVM_LOW)
    endtask: post_reset_phase


    task drive_sig();
        //req.display();
        reset_vif.cb_tb.s_rst_n <= req.reset_data;
        reset_vif.cb_tb.reg_cpu_rst_n <= req.reset_data;
    endtask: drive_sig


endclass: reset_driver

`endif
