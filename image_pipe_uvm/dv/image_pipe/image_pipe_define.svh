`ifndef __IMAGE_PIPE_DEFINE__
`define __IMAGE_PIPE_DEFINE__

    `define IMAGE_PIPE_RESET_ACTIVE 1'b0
    `define IMAGE_PIPE_RESET_INACTIVE !`IMAGE_PIPE_RESET_ACTIVE

    `define IMAGE_PIPE_VALID_ACTIVE 1'b1
    `define IMAGE_PIPE_VALID_INACTIVE !`IMAGE_PIPE_VALID_ACTIVE

    `define IMAGE_PIPE_BUSY_ACTIVE  1'b1
    `define IMAGE_PIPE_BUSY_INACTIVE  !`IMAGE_PIPE_BUSY_ACTIVE

`endif