`ifndef __U_IF__
    `define __U_IF__

interface u_if
    #(  parameter DW=32
        , parameter AW=32
        , parameter INPUT_SKEW=1ns
        , parameter OUTPUT_SKEW=1ns)
    (input logic u_clk, rst_n);

    logic          u_cs;
    logic [AW-1:0] u_addr;
    logic [DW-1:0] u_data_wr;
    logic [DW-1:0] u_data_wr;
    logic          u_we;
    logic          u_wack;
    logic          u_re;
    logic          u_rdv;

    clocking cb_tb @(posedge u_clk);
        default input #INPUT_SKEW output #OUTPUT_SKEW;

        output  u_cs, u_addr
                , u_wr_data
                , u_we, u_re;
        input u_rd_data, u_wack, u_rdv;
    endclocking

endinterface: u_if

`endif

