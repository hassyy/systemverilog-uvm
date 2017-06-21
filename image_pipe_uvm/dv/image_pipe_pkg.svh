`ifndef __IMAGE_PIPE_PKG__
    `define __IMAGE_PIPE_PKG__

package image_pipe_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "image_pipe_data.sv"
    `include "image_pipe_driver.sv"
    `include "image_pipe_busy_driver.sv"
    `include "image_pipe_monitor.sv"
    `include "image_pipe_sequencer.sv"
    `include "image_pipe_agent.sv"
    `include "image_pipe_scoreboard.sv"
    `include "image_pipe_coverage.sv"
    `include "image_pipe_env.sv"
    `include "dut_env.sv"
    `include "image_pipe_sequence_lib.sv"
    `include "test_lib.sv"

endpackage

`endif