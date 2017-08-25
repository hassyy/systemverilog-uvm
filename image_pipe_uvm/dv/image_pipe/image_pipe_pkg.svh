`ifndef __IMAGE_PIPE_PKG__
`define __IMAGE_PIPE_PKG__

package image_pipe_pkg;

     `include "image_pipe_common.svh"


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

endpackage

`endif
