`ifndef __IMAGE_PIPE_REG_CPU_SIMPLE_VSEQUENCE__
`define __IMAGE_PIPE_REG_CPU_SIMPLE_VSEQUENCE__

`include "common_header.svh"
`include "image_pipe_simple_sequence.sv"
`include "reg_cpu_normal_sequence.sv"
`include "image_pipe_base_vsequence.sv"
`include "reg_cpu_sequencer.sv"

class image_pipe_reg_cpu_simple_vsequence extends image_pipe_base_vsequence;
    // Mandatory: Factory registration
    `uvm_object_utils(image_pipe_reg_cpu_simple_vsequence)

    // Mandatory: Constructor
    function new (string name="image_pipe_reg_cpu_simple_vsequence");
        super.new(name);
    endfunction: new


    // The senario of this virtual sequencer is here.
    // We start sub-sequences.
    task body();

        // Assign sub-sequencer handles to parent
        super.body;

        // Set your sequences to run for this senario
        image_pipe_simple_sequence image_pipe_seq;
        reg_cpu_normal_sequence reg_cpu_normal_seq;

        // Instantiate
        image_pipe_seq = image_pipe_simple_sequence::type_id::create("image_pipe_seq");
        reg_cpu_normal_seq = reg_cpu_normal_seq::type_id::create("reg_cpu_normal_seq");

        // Start sequences by calling start of the sequencers
        // Sequencers are defined in parent class.
        image_pipe_seq.start(image_pipe_seqr);
        reg_cpu_seq.start(reg_cpu_seqr);

    endtask: body

endclass: image_pipe_reg_cpu_simple_vsequence

`endif