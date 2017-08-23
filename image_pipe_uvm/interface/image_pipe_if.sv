`ifndef __IMAGE_PIPE_IF__
    `define __IMAGE_PIPE_IF__

interface image_pipe_if
    #(  parameter DW_IN=32
        , parameter DW_OUT=32
        , parameter INPUT_SKEW=1ns
        , parameter OUTPUT_SKEW=1ns)
    (input logic clk, rst_n);

    logic [DW_IN-1:0]  image_pipe_data_in;
    logic              image_pipe_valid_in;
    logic              image_pipe_end_in;
    logic              image_pipe_busy_out;
    logic [DW_OUT-1:0] ipm_data_out;
    logic              ipm_valid_out;
    logic              ipm_end_out;
    logic              ipm_busy_in;

    clocking cb_tb @(posedge clk);
        default input #INPUT_SKEW output #OUTPUT_SKEW;

        // output: drived from TB (by drivers)
        output image_pipe_data_in, image_pipe_valid_in, image_pipe_end_in, ipm_busy_in;
        // input: observed from TB (by monitors)
        input ipm_data_out, ipm_valid_out, ipm_end_out, image_pipe_busy_out;
    endclocking


    clocking cb_mon @(posedge clk);
        default input #INPUT_SKEW output #OUTPUT_SKEW;

        // All ports as input for monitor
        input image_pipe_data_in, image_pipe_valid_in, image_pipe_end_in, ipm_busy_in
              , ipm_data_out, ipm_valid_out, ipm_end_out, image_pipe_busy_out;
    endclocking

endinterface: image_pipe_if

`endif