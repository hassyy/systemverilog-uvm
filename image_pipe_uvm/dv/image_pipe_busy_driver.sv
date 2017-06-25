`ifndef __IMAGE_PIPE_BUSY_DRIVER__
    `define __IMAGE_PIPE_BUSY_DRIVER__

`include "common_header.svh"
`include "image_pipe_data.sv"

class image_pipe_busy_driver #(int DW_IN, int DW_OUT) extends uvm_driver #(image_pipe_data #(DW_IN, DW_OUT));
    virtual image_pipe_if vif;

    `uvm_component_param_utils(image_pipe_busy_driver#(DW_IN, DW_OUT))

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual image_pipe_if)::get(this, "", "out_intf", vif))
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name( ), ".vif"})
        `uvm_info(get_full_name( ), "Build stage complete.", UVM_LOW)
    endfunction

    virtual task run_phase(uvm_phase phase);
        drive_busy();
    endtask: run_phase

    virtual task drive_busy( );
        forever begin
            if (vif.rst_n==1'b0)
                vif.im_busy_in = '1;
            else
                vif.im_busy_in = '0;
            @(posedge vif.clk);
        end
    endtask: drive_busy

endclass: image_pipe_busy_driver

`endif
