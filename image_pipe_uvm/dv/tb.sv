`ifndef __TB__
`define __TB__

`include "../dv/image_pipe_pkg.svh"

`include "../interface/image_pipe_if.sv"
`include "../interface/reg_cpu_if.sv"
`include "../interface/reset_if.sv"

`include "../design/image_pipe.sv"

module tb;
    import uvm_pkg::*;
    import image_pipe_pkg::*;

    bit clk;
    bit rst_n;

    image_pipe_if ivif(.clk(clk), .rst_n(rst_n));
    image_pipe_if ovif(.clk(clk), .rst_n(rst_n));
    reg_cpu_if reg_if(.reg_cpu_clk(clk), .rst_n(rst_n));
    reset_if reset_if(.clk(clk));

    image_pipe image_pipe_top(
        .clk(clk)
//         , .rst_n(rst_n)
        , .s_rst_n(reset_if.s_rst_n)
        , .reg_cpu_rst_n(reset_if.reg_cpu_rst_n)

        // Connection between DUT and TB must be the vif without clocking block.
        // Or clocking skews are not applied to DUT.
        , .image_pipe_data_in(ivif.is_data_in)
        , .image_pipe_valid_in(ivif.is_valid_in)
        , .image_pipe_end_in(ivif.is_end_in)
        , .image_pipe_busy_out(ivif.is_busy_out)

        , .image_pipe_data_out(ovif.im_data_out)
        , .image_pipe_valid_out(ovif.im_valid_out)
        , .image_pipe_end_out(ovif.im_end_out)
        , .image_pipe_busy_in(ovif.im_busy_in)

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

    task rst_gen();
        rst_n = `RESET_ACTIVE;
        repeat(`RESET_CYCLE) @(posedge clk);
        rst_n <= !`RESET_ACTIVE;
        forever @(posedge clk);
    endtask

    //assign ovif.enable=ivif.enable;

    initial begin
        fork
            rst_gen();
            clk_gen();

            // Configure virtual interface, which will assign actual interface to that of virtual
            // Or, you'll have NOVIF error (e.g. in each driver).
            uvm_config_db#(virtual image_pipe_if)::set(uvm_root::get(), "*.agent.*", "in_intf", ivif);
            uvm_config_db#(virtual image_pipe_if)::set(uvm_root::get(), "*.agent.*", "out_intf", ovif);
            uvm_config_db#(virtual image_pipe_if)::set(uvm_root::get(), "*.monitor", "monitor_intf", ovif);
            uvm_config_db#(virtual reg_cpu_if)::set(uvm_root::get(), "*.agent.*", "mst_intf", reg_if);
            uvm_config_db#(virtual reset_if)::set(uvm_root::get(), "*.reset_agt.*", "reset_if", reset_if);

            // UVM start test.
            run_test();
        join_any
    end

endmodule

`endif
