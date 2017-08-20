`ifndef __RESET_SEQUENCE__
`define __RESET_SEQUENCE__

`include "define.svh"
`include "reset_transaction.sv"

class reset_sequence extends uvm_sequence #(reset_transaction);

    // Mandatory: Factory registration
    `uvm_object_utils(reset_sequence)

    function new(input string name="reset_sequence");
        super.new(name);
        `uvm_info(get_name(), $sformatf("HIERACHY: %m"), UVM_HIGH)
    endfunction: new

    virtual task body();
        // For PRE_RESET
        `uvm_do_with(req, {reset_data==`RESET_INACTIVE;})
        // For RESET
        `uvm_do_with(req, {reset_data==`RESET_ACTIVE;})
        `uvm_do_with(req, {reset_data==`RESET_INACTIVE;})
    endtask;


    // House keeping codes:
    virtual task pre_start();
        if (starting_phase!=null)
            starting_phase.raise_objection(this);
    endtask: pre_start

    virtual task post_start();
        if (starting_phase!=null)
            starting_phase.drop_objection(this);
    endtask: post_start

endclass: reset_sequence


`endif