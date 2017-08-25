`ifndef __RESET_INTERFACE__
`define __RESET_INTERFACE__

interface reset_if
    #(  parameter INPUT_SKEW=1ns
        , parameter OUTPUT_SKEW=1ns)
    (input logic clk);

    logic s_rst_n;
    logic reg_cpu_rst_n;

    clocking cb_tb @(posedge clk);
        default input #INPUT_SKEW output #OUTPUT_SKEW;

        // output: drived from TB (drivers)
        output s_rst_n, reg_cpu_rst_n;

    endclocking
endinterface: reset_if


`endif
