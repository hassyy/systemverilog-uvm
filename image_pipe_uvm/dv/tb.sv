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

    always #5 clk=~clk;

    initial begin
        #5 rst_n=1'b0;
        #25 rst_n=1'b1;
    end

    //assign ovif.enable=ivif.enable;

    initial begin
        // Set vif according to defined interface name (in_intf/out_intf)
        uvm_config_db#(virtual image_pipe_if)::set(uvm_root::get( ), "*.agent.*", "in_intf", ivif);
        uvm_config_db#(virtual image_pipe_if)::set(uvm_root::get( ), "*.agent.*", "out_intf", ovif);
        uvm_config_db#(virtual image_pipe_if)::set(uvm_root::get( ), "*.monitor", "monitor_intf", ovif);

        run_test();
    end

endmodule

`endif