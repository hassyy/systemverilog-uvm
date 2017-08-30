`ifndef __TB__
`define __TB__

`include "../dv/dut_env/dut_env_define.svh"

import image_pipe_pkg::*;
import test_pkg::*;

module tb;
    import uvm_pkg::*;

    localparam DW_IN = `DUT_IMAGE_PIPE_DW_IN;
    localparam DW_OUT = `DUT_IMAGE_PIPE_DW_OUT;
    localparam AW = `DUT_REG_CPU_AW;
    localparam DW = `DUT_REG_CPU_DW;

    bit clk;
    bit rst_n;

    reset_if reset_if(.clk(clk));

    image_pipe_if #(.DW_IN(DW_IN) , .DW_OUT(DW_OUT)) vif_in(.clk(clk), .rst_n(reset_if.s_rst_n));
    image_pipe_if #(.DW_IN(DW_IN), .DW_OUT(DW_OUT)) vif_out(.clk(clk), .rst_n(reset_if.s_rst_n));
    reg_cpu_if #(.AW(AW), .DW(DW)) reg_if(.reg_cpu_clk(clk), .rst_n(reset_if.reg_cpu_rst_n));

    image_pipe image_pipe_top(
        .clk(clk)
        , .s_rst_n(reset_if.s_rst_n)
        , .reg_cpu_rst_n(reset_if.reg_cpu_rst_n)

        // Connection between DUT and TB must be the vif without clocking block.
        // Or clocking skews are not applied to DUT.
        , .image_pipe_data_in(vif_in.image_pipe_data_in)
        , .image_pipe_valid_in(vif_in.image_pipe_valid_in)
        , .image_pipe_end_in(vif_in.image_pipe_end_in)
        , .image_pipe_busy_out(vif_in.image_pipe_busy_out)

        , .image_pipe_data_out(vif_out.ipm_data_out)
        , .image_pipe_valid_out(vif_out.ipm_valid_out)
        , .image_pipe_end_out(vif_out.ipm_end_out)
        , .image_pipe_busy_in(vif_out.ipm_busy_in)

        , .reg_cpu_cs(reg_if.reg_cpu_cs)
        , .reg_cpu_addr(reg_if.reg_cpu_addr[31:2])
        , .reg_cpu_data_wr(reg_if.reg_cpu_data_wr)
        , .reg_cpu_data_rd(reg_if.reg_cpu_data_rd)
        , .reg_cpu_we(reg_if.reg_cpu_we)
        , .reg_cpu_wack(reg_if.reg_cpu_wack)
        , .reg_cpu_re(reg_if.reg_cpu_re)
        , .reg_cpu_rdv(reg_if.reg_cpu_rdv)
    );

    // TASKs
    task clk_gen();
        clk = 0;
        forever #(`CLK_PERIOD/2) clk=!clk;
    endtask

    /*
    task rst_gen();
        rst_n = `RESET_ACTIVE;
        repeat(`RESET_CYCLE) @(posedge clk);
        rst_n <= !`RESET_ACTIVE;
        forever @(posedge clk);
    endtask
    */

    //assign vif_out.enable=vif_in.enable;

    initial begin
        fork
            // rst_gen();
            clk_gen();

            // Configure virtual interface, which will assign actual interface to that of virtual
            // Or, you'll have NOVIF error (e.g. in each driver).

            // Also, you must set the generic parameter to virtual interface to have the same param.
            // Or, you'll have Illegal assingment error.
            //   "interface must be assigned a matching interface or virtual interface."
            uvm_config_db#( virtual image_pipe_if#(.DW_IN(DW_IN), .DW_OUT(DW_OUT))
                            )::set( uvm_root::get()
                                    , "*.agent.*"   // Search path of hierachy in config_db
                                    , "in_intf"     // Target string of interaface to be searched
                                    , vif_in        // Set this to the searched interface
                                    );
            uvm_config_db#(virtual image_pipe_if#(.DW_IN(DW_IN), .DW_OUT(DW_OUT)))::set(uvm_root::get(), "*.agent.*", "out_intf", vif_out);
            uvm_config_db#(virtual reg_cpu_if#(.AW(AW), .DW(DW)))::set(uvm_root::get(), "*.agent.*", "reg_cpu_if", reg_if);
            uvm_config_db#(virtual reset_if)::set(uvm_root::get(), "*.rst_agent.*", "reset_if", reset_if);

            // UVM start test.
            run_test();
        join_any
    end

endmodule

`endif
