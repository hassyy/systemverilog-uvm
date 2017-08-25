`ifndef __DUT_ENV_DEFINE__
`define __DUT_ENV_DEFINE__

    `define RESET_ACTIVE 1'b0
    `define RESET_INACTIVE !`RESET_ACTIVE
    `define RESET_CYCLE 2
    `define CLK_PERIOD 10

    `define DUT_IMAGE_PIPE_DW_IN  8
    `define DUT_IMAGE_PIPE_DW_OUT 8

    `define DUT_REG_CPU_AW 32
    `define DUT_REG_CPU_DW 32

`endif
