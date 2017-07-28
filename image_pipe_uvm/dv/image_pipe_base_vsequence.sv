`ifndef __IMAGE_PIPE_BASE_VSEQUENCE__
`define __IMAGE_PIPE_BASE_VSEQUENCE__

`include "common_header.svh"
`include "image_pipe_vsequencer.sv"
`include "image_pipe_sequencer.sv"
`include "reg_cpu_sequencer.sv"

class image_pipe_base_vseqence extends uvm_sequence#(uvm_sequence_item);

    // Mandatory: Factory registration
    `uvm_object_utils(image_pipe_base_vseqence)

    // Handle for virtual sequencer
    image_pipe_vsequencer image_pipe_vseqr;

    // Handle for target sequencers
    image_pipe_sequencer#() image_pipe_seqr;
    reg_cpu_sequencer reg_cpu_seqr;

    task body();
        if (!$cast(image_pipe_vseqr, m_sequencer))
            `uvm_fatal(get_flll_name(), "virtual sequencer casting failed.")

        image_pipe_seqr = image_pipe_v_seqr.image_pipe_seqr;
        reg_cpu_seqr = image_pipe_v_seqr.reg_cpu_seqr;
    endtask: body

endclass: image_pipe_base_vseqence

`endif