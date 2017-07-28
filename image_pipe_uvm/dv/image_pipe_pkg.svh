`ifndef __IMAGE_PIPE_PKG__
`define __IMAGE_PIPE_PKG__

package image_pipe_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "define.svh"
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

    `include "dut_reg_1_reg.sv"
    `include "dut_reg_2_reg.sv"
    `include "dut_reg_block.sv"
    `include "dut_reg_adapter.sv"

    `include "reg_cpu_data.sv"
    `include "reg_cpu_driver.sv"
    `include "reg_cpu_sequencer.sv"
    `include "reg_cpu_reg_predictor.sv"
    `include "reg_cpu_env.sv"
    `include "reg_cpu_sequence_lib.sv"

    `include "dut_env.sv"
    `include "test_lib.sv"

    `include "image_pipe_primary_test.sv"

endpackage

`endif
