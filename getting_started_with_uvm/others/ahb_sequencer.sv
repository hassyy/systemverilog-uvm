`include "ahb_transfer.sv"

class ahb_sequencer extends uvm_sequencer #(ahb_transfer);

    `uvm_sequencer_utils(ahb_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

endclass: ahb_sequencer