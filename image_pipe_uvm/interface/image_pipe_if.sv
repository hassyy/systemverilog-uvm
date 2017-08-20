`ifndef __IMAGE_PIPE_IF__
    `define __IMAGE_PIPE_IF__

interface image_pipe_if
    #(  parameter DW_IN=32
        , parameter DW_OUT=32
        , parameter INPUT_SKEW=1ns
        , parameter OUTPUT_SKEW=1ns)
    (input logic clk, rst_n);

    logic [DW_IN-1:0]  is_data_in;
    logic              is_valid_in;
    logic              is_end_in;
    logic              is_busy_out;
    logic [DW_OUT-1:0] im_data_out;
    logic              im_valid_out;
    logic              im_end_out;
    logic              im_busy_in;

    clocking cb_tb @(posedge clk);
        default input #INPUT_SKEW output #OUTPUT_SKEW;

        // output: drived from TB (by drivers)
        output is_data_in, is_valid_in, is_end_in, im_busy_in;
        // input: observed from TB (by monitors)
        input im_data_out, im_valid_out, im_end_out, is_busy_out;
    endclocking


    clocking cb_mon @(posedge clk);
        default input #INPUT_SKEW output #OUTPUT_SKEW;

        // All ports as input for monitor
        input is_data_in, is_valid_in, is_end_in, im_busy_in
              , im_data_out, im_valid_out, im_end_out, is_busy_out;
    endclocking

endinterface: image_pipe_if

`endif