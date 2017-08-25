`ifndef __TEST_DEFINE__
`define __TEST_DEFINE__

    // Use the defines of dut_env for generic parameters for each test
    `include "../dv/dut_env/dut_env_define.svh"

    `define TEST_IMAGE_PIPE_DW_IN `DUT_IMAGE_PIPE_DW_IN
    `define TEST_IMAGE_PIPE_DW_OUT `DUT_IMAGE_PIPE_DW_OUT

    `define TEST_REG_CPU_AW `DUT_REG_CPU_AW
    `define TEST_REG_CPU_DW `DUT_REG_CPU_DW

`endif
