`ifndef __DUT_VSEQUENCER__
`define __DUT_VSEQUENCER__

`include "sequence_common.svh"

class dut_vsequencer#(int DW_IN, int DW_OUT, int AW, int DW) extends uvm_sequencer;

    // Mandatory: Factory registration
    `uvm_component_param_utils(dut_vsequencer#(DW_IN, DW_OUT, AW, DW))

    // Handles for target sequencer
    image_pipe_sequencer#(DW_IN, DW_OUT) image_pipe_seqr;
    image_pipe_busy_sequencer#(DW_IN, DW_OUT) image_pipe_busy_seqr;
    reg_cpu_sequencer#(AW, DW) reg_cpu_seqr;
    reset_sequencer reset_seqr;

    // Mandatory:
    function new (string name="dut_vsequencer", uvm_component parent);
        super.new(name, parent);
    endfunction: new

endclass: dut_vsequencer

`endif
