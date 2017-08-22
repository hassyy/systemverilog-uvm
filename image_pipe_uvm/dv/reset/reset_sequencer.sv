`ifndef __RESET_SEQUENCER__
`define __RESET_SEQUENCER__

`include "reset_common.svh"
`include "reset_transaction.sv"


class reset_sequencer extends uvm_sequencer #(reset_transaction);

    // Mandatory: Factory registration
    `uvm_sequencer_param_utils(reset_sequencer)

    // Mandatory:
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

endclass: reset_sequencer

`endif
