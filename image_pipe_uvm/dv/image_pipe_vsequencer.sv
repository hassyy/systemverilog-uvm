`ifndef __IMAGE_PIPE_VSEQUENCER__
`define __IMAGE_PIPE_VSEQUENCER__

`include "common_header.svh"
`include "image_pipe_sequencer.sv"
`include "image_pipe_busy_sequencer.sv"
`include "reg_cpu_sequencer.sv"
`include "reset_sequencer.sv"

class image_pipe_vsequencer extends uvm_sequencer#();

    // Mandatory: Factory registration
    `uvm_component_utils(image_pipe_vsequencer)

    // Handles for target sequencer
    image_pipe_sequencer#() image_pipe_seqr;
    image_pipe_busy_sequencer image_pipe_busy_seqr;
    reg_cpu_sequencer reg_cpu_seqr;
    reset_sequencer reset_seqr;

    // Mandatory:
    function new (string name="image_pipe_vsequencer", uvm_component parent);
        super.new(name, parent);
    endfunction: new

endclass: image_pipe_vsequencer

`endif
