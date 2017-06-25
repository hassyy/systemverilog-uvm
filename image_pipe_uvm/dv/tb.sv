`ifndef __TB__
    `define __TB__


module tb;
    import uvm_pkg::*;
    import image_pipe_pkg::*;

    bit clk;
    bit rst_n;

    image_pipe_if ivif(.clk(clk), .rst_n(rst_n));
    image_pipe_if ovif(.clk(clk), .rst_n(rst_n));

    image_pipe image_pipe_top(
        .clk(clk)
        , .rst_n(rst_n)

        , .is_data_in(ivif.is_data_in)
        , .is_valid_in(ivif.is_valid_in)
        , .is_end_in(ivif.is_end_in)
        , .is_busy_out(ivif.is_busy_out)

        , .im_data_out(ovif.im_data_out)
        , .im_valid_out(ovif.im_valid_out)
        , .im_end_out(ovif.im_end_out)
        , .im_busy_in(ovif.im_busy_in)
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

            // UVM config_db setting
            uvm_config_db#(virtual image_pipe_if)::set(uvm_root::get( ), "*.agent.*", "in_intf", ivif);
            uvm_config_db#(virtual image_pipe_if)::set(uvm_root::get( ), "*.agent.*", "out_intf", ovif);
            uvm_config_db#(virtual image_pipe_if)::set(uvm_root::get( ), "*.monitor", "monitor_intf", ovif);
            // UVM start test.
            run_test();
        join_any
    end

endmodule

`endif