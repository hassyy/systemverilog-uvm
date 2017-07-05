`ifndef __IMAGE_PIPE_BUSY_DRIVER__
    `define __IMAGE_PIPE_BUSY_DRIVER__

`include "common_header.svh"
`include "image_pipe_data.sv"

class image_pipe_busy_driver #(int DW_IN=32, int DW_OUT=32) extends uvm_driver #(image_pipe_data #(DW_IN, DW_OUT));
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
        fork
            reset();
            get_and_drive();
        join
    endtask: run_phase

    virtual task reset();
        forever begin
            `uvm_info(get_type_name(), "Resetting signals ", UVM_LOW)
            vif.im_busy_in= '0;
            @(negedge vif.rst_n);
        end
    endtask: reset

    virtual task get_and_drive( );
        forever begin
            @(posedge vif.rst_n);
            while (vif.rst_n != 1'b0) begin
                seq_item_port.get_next_item(req);
                drive_busy(req);
                seq_item_port.item_done( );
            end
        end
    endtask: get_and_drive

    virtual task drive_busy(image_pipe_data#() req);
        vif.im_busy_in = vif.im_busy_in;

        repeat(req.busy_interval) @(posedge vif.clk);

        vif.im_busy_in = req.im_busy_in;
        @(posedge vif.clk);
    endtask: drive_busy

endclass: image_pipe_busy_driver

`endif
