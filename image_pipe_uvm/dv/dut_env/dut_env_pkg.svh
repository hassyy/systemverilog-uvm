`ifndef __DUT_ENV_PKG__
`define __DUT_ENV_PKG__

package dut_env_pkg;

    `include "dut_env_common.svh"

    import image_pipe_pkg::*;
    import reg_cpu_pkg::*;
    import reset_pkg::*;
    import dut_reg_pkg::*;
    import sequence_pkg::*;

    `include "dut_env.sv"

endpackage

`endif
