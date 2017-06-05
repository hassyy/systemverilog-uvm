`ifndef __PIPE_PKG__
    `define __PIPE_PKG__

package pipe_pkg;
    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "data_packet.sv"
    `include "pipe_driver.sv"
    `include "pipe_monitor.sv"
    `include "pipe_sequencer.sv"
    `include "pipe_agent.sv"
    `include "pipe_scoreboard.sv"
    `include "pipe_coverage.sv"
    `include "pipe_env.sv"
    `include "dut_env.sv"
    `include "pipe_sequence_lib.sv"
    `include "test_lib.sv"

endpackage

`endif