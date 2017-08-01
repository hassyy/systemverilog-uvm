`ifndef __IMAGE_PIPE_BUSY_SEQUENCER__
    `define __IMAGE_PIPE_BUSY_SEQUENCER__

`include "common_header.svh"
`include "image_pipe_data.sv"


class image_pipe_busy_sequencer extends uvm_sequencer #(image_pipe_data#());
    `uvm_sequencer_param_utils(image_pipe_busy_sequencer)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

endclass: image_pipe_busy_sequencer

`endif
