`ifndef __SEQUENCE_PKG__
`define __SEQUENCE_PKG__

package sequence_pkg;

    `include "sequence_common.svh"

    `include "dut_vsequencer.sv"

    `include "image_pipe_sequence_lib.sv"
    `include "image_pipe_busy_sequence_lib.sv"
    `include "reg_cpu_sequence_lib.sv"
    `include "image_pipe_vsequence_base.sv"
    `include "image_pipe_reg_cpu_simple_vsequence.sv"

endpackage

`endif
