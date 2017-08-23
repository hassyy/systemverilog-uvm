`ifndef __IMAGE_PIPE_VSEQUENCER__
`define __IMAGE_PIPE_VSEQUENCER__

`include "sequence_common.svh"
import image_pipe_pkg::*;
import reg_cpu_pkg::*;
import reset_pkg::*;

class image_pipe_vsequencer#(int DW_IN, int DW_OUT) extends uvm_sequencer#();

    // Mandatory: Factory registration
    `uvm_component_utils(image_pipe_vsequencer#(DW_IN, DW_OUT))

    // Handles for target sequencer
    image_pipe_sequencer#(DW_IN, DW_OUT) image_pipe_seqr;
    image_pipe_busy_sequencer#(DW_IN, DW_OUT) image_pipe_busy_seqr;
    reg_cpu_sequencer reg_cpu_seqr;
    reset_sequencer reset_seqr;

    // Mandatory:
    function new (string name="image_pipe_vsequencer", uvm_component parent);
        super.new(name, parent);
    endfunction: new

endclass: image_pipe_vsequencer

`endif