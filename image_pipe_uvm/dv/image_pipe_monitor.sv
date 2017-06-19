`ifndef __IMAGE_PIPE_MONITOR__
    `define __IMAGE_PIPE_MONITOR__

`include "common_header.svh"
`include "image_pipe_data.sv"


class image_pipe_monitor extends uvm_monitor;
    virtual image_pipe_if vif;
    string monitor_intf;
    int num_data;

    uvm_analysis_port #(image_pipe_data) item_collected_port;
    image_pipe_data data_collected;
    image_pipe_data data_clone;

    `uvm_component_utils(image_pipe_monitor)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(string)::get(this, "", "monitor_intf", monitor_intf))
            `uvm_fatal("NOSTRING", {"Need interface name for: ", get_full_name( ), ".monitor_intf"})

        `uvm_info(get_type_name( ), $sformatf("INTERFACE USED = %0s", monitor_intf), UVM_LOW)

        if (!uvm_config_db#(virtual pipe_if)::get(this, "", monitor_intf, vif))
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name( ), ".vif"})

        item_collected_port = new("item_collected_port", this);
        data_collected = image_pipe_data::type_id::create("data_collected");

        data_clone = image_pipe_data::type_id::create("data_clone");

        `uvm_info(get_full_name( ), "Build stage complete.", UVM_LOW)
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);
        collect_data( );
    endtask: run_phase

    virtual task collect_data( );
        forever begin
            // wait(vif.is_valid_in & !vif.is_busy_out);
            // data_collected.is_data_in = vif.is_data_in;
            // data_collected.is_valid_in = vif.is_valid_in;
            // data_collected.is_end_in = vif.is_end_in;
            //repeat(3) @(posedge vif.clk);

            // Wait for VALID output data to collect
            wait(vif.im_valid_out & !vif.im_busy_in);
            data_collected.im_data_out  = vif.im_data_out;
            data_collected.im_valid_out = vif.im_valid_out;
            data_collected.im_end_out = vif.im_end_out;
            $cast(data_clone, data_collected.clone( ));
            item_collected_port.write(data_clone);
            num_data++;
        end
    endtask: collect_data

    virtual function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name( ), $sformatf("REPORT: COLLECTED PACKETS = %0d", num_data), UVM_LOW)
    endfunction : report_phase

endclass : image_pipe_monitor

`endif
