`ifndef __IMAGE_PIPE_IF__
    `define __IMAGE_PIPE_IF__

interface image_pipe_if
    #(parameter DW_IN=32, parameter DW_OUT=32)
    (input logic clk, rst_n);

    logic [DW_IN-1:0]  is_data_in;
    logic              is_valid_in;
    logic              is_end_in;
    logic              is_busy_out;
    logic [DW_OUT-1:0] im_data_out;
    logic              im_valid_out;
    logic              im_end_out;
    logic              im_busy_in;
endinterface: image_pipe_if

`endif