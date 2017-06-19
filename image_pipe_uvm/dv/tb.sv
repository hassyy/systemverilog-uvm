`ifndef __TB__
    `define __TB__


module tb;
    import uvm_pkg::*;
    import pipe_pkg::*;

    bit clk;
    bit rst_n;

    image_pipe_if ivif(.clk(clk), .rst_n(rst_n));
    image_pipe_if ovif(.clk(clk), .rst_n(rst_n));

    image_pipe image_pipe_top(
        .clk(clk)
        , .rst_n(rst_n)

        , .i_data0(ivif.data_in0)
        , .o_data0(ivif.data_out0)
    );

    always #5 clk=~clk;

    initial begin
        #5 rst_n=1'b0;
        #25 rst_n=1'b1;
    end

    assign ovif.enable=ivif.enable;

    initial begin
        uvm_config_db#(virtual pipe_if)::set(uvm_root::get( ), "*.agent.*", "in_intf", ivif);
        uvm_config_db#(virtual pipe_if)::set(uvm_root::get( ), "*.monitor", "out_intf", ovif);

        run_test();
    end

endmodule

`endif