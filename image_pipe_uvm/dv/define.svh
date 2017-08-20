`ifndef __DEFINE__
    `define __DEFINE__

    `define RESET_ACTIVE 1'b0
    `define RESET_INACTIVE !`RESET_ACTIVE
    `define RESET_CYCLE 2
    `define CLK_PERIOD 10

    `define IMAGE_PIPE_DW_IN1 8
    `define IMAGE_PIPE_DW_OUT1 8

`endif