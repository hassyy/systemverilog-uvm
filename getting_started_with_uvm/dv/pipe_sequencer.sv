`ifndef __PIPE_SEQUENCER__
    `define __PIPE_SEQUENCER__

// `include "common_header.svh"
// `include "data_packet.sv"


class pipe_sequencer extends uvm_sequencer #(data_packet);
    `uvm_sequencer_utils(pipe_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

endclass: pipe_sequencer

`endif
