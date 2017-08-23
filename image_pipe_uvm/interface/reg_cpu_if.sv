`ifndef __REG_CPU_IF__
    `define __REG_CPU_IF__

interface reg_cpu_if
    #(  parameter DW=32
        , parameter AW=32
        , parameter INPUT_SKEW=1ns
        , parameter OUTPUT_SKEW=1ns)
    (input logic reg_cpu_clk, rst_n);

    logic          reg_cpu_cs;
    logic [AW-1:0] reg_cpu_addr;
    logic [DW-1:0] reg_cpu_data_wr;
    logic [DW-1:0] reg_cpu_data_rd;
    logic          reg_cpu_we;
    logic          reg_cpu_wack;
    logic          reg_cpu_re;
    logic          reg_cpu_rdv;

    clocking cb_tb @(posedge reg_cpu_clk);
        default input #INPUT_SKEW output #OUTPUT_SKEW;

        output  reg_cpu_cs, reg_cpu_addr
                , reg_cpu_data_wr
                , reg_cpu_we, reg_cpu_re;
        input reg_cpu_data_rd, reg_cpu_wack, reg_cpu_rdv;
    endclocking

endinterface: reg_cpu_if

`endif

