`ifndef __TEST_PKG__
`define __TEST_PKG__

package test_pkg;

    `include "test_common.svh"

    // import all packages
    import image_pipe_pkg::*;
    import reg_cpu_pkg::*;
    import reset_pkg::*;
    import dut_env_pkg::*;
    import dut_reg_pkg::*;
    import sequence_pkg::*;

    `include "test_lib.sv"
    `include "image_pipe_primary_test.sv"

endpackage

`endif
