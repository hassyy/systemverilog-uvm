`ifndef __PIPE_IF__
    `define __PIPE_IF__

interface pipe_if (input logic clk, rst_n);
    logic [ 1:0] cf;
    logic [15:0] data_in0;
    logic [15:0] data_in1;
    logic [15:0] data_out0;
    logic [15:0] data_out1;
    logic        enable;
endinterface: pipe_if

`endif