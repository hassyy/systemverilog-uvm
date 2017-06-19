`ifndef __IMAGE_PIPE_SEQUENCER__
    `define __IMAGE_PIPE_SEQUENCER__

`include "common_header.svh"
`include "image_pipe_data.sv"


class image_pipe_sequencer extends uvm_sequencer #(image_pipe_data);
    `uvm_sequencer_utils(image_pipe_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

endclass: image_pipe_sequencer

`endif
