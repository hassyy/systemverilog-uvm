`ifndef __IMAGE_PIPE_BASE_VSEQUENCE__
`define __IMAGE_PIPE_BASE_VSEQUENCE__

`include "sequence_common.svh"

//class image_pipe_vsequence_base#(int DW_IN, int DW_OUT, int AW, int DW) extends uvm_sequence#();
class image_pipe_vsequence_base#(int DW_IN, int DW_OUT, int AW, int DW) extends uvm_sequence;

    // Mandatory: Factory registration
    `uvm_object_param_utils(image_pipe_vsequence_base#(DW_IN, DW_OUT, AW, DW))

    // Create handle for virtual sequencer with UVM MACRO
    // You can point this virtual sequencer via p_sequencer in inherited class.
    //`uvm_declare_p_sequencer(dut_vsequencer#(DW_IN, DW_OUT, AW, DW))

    dut_vsequencer#(DW_IN, DW_OUT, AW, DW) v_seqr;

    // Handle for target sequencers
    image_pipe_sequencer#(DW_IN, DW_OUT) image_pipe_seqr;
    image_pipe_busy_sequencer#(DW_IN, DW_OUT) image_pipe_busy_seqr;
    reg_cpu_sequencer#(AW, DW) reg_cpu_seqr;
    reset_sequencer reset_seqr;


    // Mandatory: This "new" is the type for uvm_object (no parent)
    function new (string name="image_pipe_vsequence_base");
        super.new(name);
    endfunction: new


    // Objection control. This is a common housekeeping code
    virtual task pre_body();
        if (starting_phase!=null)
            starting_phase.raise_objection(this, "VSEQ_STARTED");
    endtask: pre_body

    // Assign pointers to the sub-sequences here in the body() of base class
    task body();
        if (!$cast(v_seqr, m_sequencer))
            `uvm_fatal(get_full_name(), "VIRTUALL_SEQ POINTER CAST FAILED")
        if (v_seqr.image_pipe_seqr==null)
            `uvm_fatal(get_full_name(), "NULL_POINTER_EXCEPTION: image_pipe_seqr")
        if (v_seqr.image_pipe_busy_seqr==null)
            `uvm_fatal(get_full_name(), "NULL_POINTER_EXCEPTION: image_pipe_busy_seqr")
        if (v_seqr.reg_cpu_seqr==null)
            `uvm_fatal(get_full_name(), "NULL_POINTER_EXCEPTION: reg_cpu_seqr")
        if (v_seqr.reset_seqr==null)
            `uvm_fatal(get_full_name(), "NULL_POINTER_EXCEPTION: reset_seqr")

        `uvm_info(get_full_name(), "ASSIGN ACTUAL SEQ to VSEQ", UVM_LOW)
        image_pipe_seqr = v_seqr.image_pipe_seqr;
        image_pipe_busy_seqr = v_seqr.image_pipe_busy_seqr;
        reg_cpu_seqr = v_seqr.reg_cpu_seqr;
        reset_seqr = v_seqr.reset_seqr;
    endtask: body

    virtual task post_body();
        if (starting_phase!=null)
            starting_phase.drop_objection(this, "VSEQ_DONE");
    endtask: post_body

endclass: image_pipe_vsequence_base

`endif
