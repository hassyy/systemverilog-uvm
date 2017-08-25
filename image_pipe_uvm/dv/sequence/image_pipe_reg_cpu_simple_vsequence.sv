`ifndef __IMAGE_PIPE_REG_CPREG_CPU_SIMPLE_VSEQUENCE__
`define __IMAGE_PIPE_REG_CPREG_CPU_SIMPLE_VSEQUENCE__

`include "sequence_common.svh"

class image_pipe_reg_cpreg_cpu_simple_vsequence#(int DW_IN, int DW_OUT, int AW, int DW)
    extends image_pipe_vsequence_base#(DW_IN, DW_OUT, AW, DW);

    // Mandatory: Factory registration
    `uvm_object_param_utils(image_pipe_reg_cpreg_cpu_simple_vsequence#(DW_IN, DW_OUT, AW, DW))

    // Handle for target sequencers
    // Declare sequences to use for your virtual sequence
    image_pipe_simple_sequence#(DW_IN, DW_OUT) image_pipe_seq;
    image_pipe_normal_busy_sequence#(DW_IN, DW_OUT) image_pipe_busy_seq;
    reg_cpu_normal_sequence#(AW, DW)  reg_cpu_seq;
    reset_sequence reset_seq;

    // Mandatory: Constructor. This is the style for uvm_object.
    function new (string name="image_pipe_reg_cpreg_cpu_simple_vsequence");
        super.new(name);
    endfunction: new


    // The senario of this virtual sequencer is here.
    // We start sub-sequences.
    task body();

        // Call body() in base class to assign sequencers.
        super.body;

        // Instanciate seqeucnes by Factory method.
        reset_seq = reset_sequence::type_id::create("reset_seq");
        image_pipe_seq = image_pipe_simple_sequence#(DW_IN, DW_OUT)::type_id::create("image_pipe_seq");
        image_pipe_busy_seq = image_pipe_normal_busy_sequence#(DW_IN, DW_OUT)::type_id::create("image_pipe_busy_seq");
        if (reg_cpu_seq==null)
            reg_cpu_seq = reg_cpu_normal_sequence#(AW,DW)::type_id::create("reg_cpu_seq");
        else
            // This is the case that reg_cpu_seq is instantiated in test for assiging reg_block(RAL).
            `uvm_info(get_full_name, "SKIP_INSTANTIATION: reg_cpu_seq", UVM_LOW)


        // Randomise sequences before starting.
        assert(reset_seq.randomize());
        assert(image_pipe_seq.randomize());
        assert(image_pipe_busy_seq.randomize());

        `uvm_info(get_full_name(), "START_SEQs_IN_VSEQ", UVM_LOW)

        // [STEP1] Reset
        reset_seq.start(reset_seqr);

        // [STEP2] Set registers
        reg_cpu_seq.start(reg_cpu_seqr);

        // [STEP3] Start IMAGE_PIPEBUS transaction
        // Quit after image_pipe_seq is finished.
        fork
            image_pipe_seq.start(image_pipe_seqr);
            image_pipe_busy_seq.start(image_pipe_busy_seqr);
        join_any

    endtask: body

endclass: image_pipe_reg_cpreg_cpu_simple_vsequence

`endif
