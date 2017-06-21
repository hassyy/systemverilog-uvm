`ifndef __IMAGE_PIPE_IF__
    `define __IMAGE_PIPE_IF__

interface image_pipe_if (input logic clk, rst_n);
    logic [31:0] is_data_in;
    logic        is_valid_in;
    logic        is_end_in;
    logic        is_busy_out;
    logic [31:0] im_data_out;
    logic        im_valid_out;
    logic        im_end_out;
    logic        im_busy_in;
endinterface: image_pipe_if

`endif