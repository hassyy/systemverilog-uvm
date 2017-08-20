`ifndef __IMAGE_PIPE_PKG__
`define __IMAGE_PIPE_PKG__

package image_pipe_pkg;

    import uvm_pkg::*;
     `include "uvm_macros.svh"

    `include "image_pipe_define.svh"

    `include "image_pipe_data.sv"

    `include "image_pipe_driver.sv"
    `include "image_pipe_busy_driver.sv"
    `include "image_pipe_monitor.sv"
    `include "image_pipe_sequencer.sv"
    `include "image_pipe_busy_sequencer.sv"
    `include "image_pipe_agent.sv"
    `include "image_pipe_scoreboard.sv"
    `include "image_pipe_coverage.sv"
    `include "image_pipe_env.sv"
    `include "image_pipe_sequence_lib.sv"

    // `include "image_pipe_vsequence_base.sv"
    // `include "image_pipe_reg_cpu_simple_vsequence.sv"
    // `include "image_pipe_vsequencer.sv"

endpackage

`endif
