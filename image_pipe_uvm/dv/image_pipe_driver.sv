`ifndef __IMAGE_PIPE_DRIVER__
    `define __IMAGE_PIPE_DRIVER__

`include "common_header.svh"
`include "image_pipe_data.sv"

class image_pipe_driver extends uvm_driver #(image_pipe_data);
    virtual image_pipe_if vif;

    `uvm_component_utils(image_pipe_driver)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual image_pipe_if)::get(this, "", "in_intf", vif))
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name( ), ".vif"})
        `uvm_info(get_full_name( ), "Build stage complete.", UVM_LOW)
    endfunction

    virtual task run_phase(uvm_phase phase);
        fork
            reset( );
            get_and_drive( );
        join
    endtask: run_phase

    virtual task reset( );
        forever begin
            @(negedge vif.rst_n);
            `uvm_info(get_type_name( ), "Resetting signals ", UVM_LOW)
            vif.is_data_in  = '0;
            vif.is_valid_in = '0;
            vif.is_end_in   = '0;
        end
    endtask: reset

    virtual task get_and_drive( );
        forever begin
            @(posedge vif.rst_n);
            while (vif.rst_n != 1'b0) begin
                seq_item_port.get_next_item(req);
                drive_data(req);
                seq_item_port.item_done( );
            end
        end
    endtask: get_and_drive

    virtual task drive_data(image_pipe_data data_tmp);

        vif.is_data_in  = data_tmp.is_data_in;
        vif.is_valid_in = data_tmp.is_valid_in;
        vif.is_end_in   = data_tmp.is_end_in;

        @(posedge vif.clk);
    endtask: drive_data

endclass: image_pipe_driver

`endif
