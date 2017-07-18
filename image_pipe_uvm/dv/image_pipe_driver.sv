`ifndef __IMAGE_PIPE_DRIVER__
    `define __IMAGE_PIPE_DRIVER__

`include "common_header.svh"
`include "define.svh"
`include "image_pipe_define.svh"
`include "image_pipe_data.sv"

class image_pipe_driver #(int DW_IN=32, int DW_OUT=32) extends uvm_driver #(image_pipe_data#(DW_IN, DW_OUT));
    virtual image_pipe_if vif;

    `uvm_component_param_utils(image_pipe_driver#(DW_IN, DW_OUT))

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual image_pipe_if)::get(this, "", "in_intf", vif))
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name( ), ".vif"})
    endfunction

    virtual task run_phase(uvm_phase phase);
        fork
            reset();
            get_and_drive();
        join
    endtask: run_phase

    virtual task reset( );
        forever begin
            `uvm_info(get_type_name( ), "Resetting signals ", UVM_LOW)
            vif.cb_tb.is_data_in  <= '0;
            vif.cb_tb.is_valid_in <= '0;
            vif.cb_tb.is_end_in   <= '0;
            @(negedge vif.rst_n);
        end
    endtask: reset

    virtual task get_and_drive( );
        forever begin
            @(posedge vif.rst_n);
            while (vif.rst_n != `RESET_ACTIVE) begin
                seq_item_port.get_next_item(req);
                drive_sig(req);
                seq_item_port.item_done( );
            end
        end
    endtask: get_and_drive

    virtual task drive_sig(image_pipe_data#(DW_IN, DW_OUT) req);

        // Wait during reset
        // FYI) "iff(condition)" is "while (condition is FALSE)""
        @(posedge vif.cb_tb iff(vif.rst_n!=`RESET_ACTIVE));

        if (req.first_data_flag)
            repeat(req.wait_before_transmit) @(posedge vif.cb_tb);
        else
        if (req.last_data_flag)
            repeat(req.wait_before_end) @(posedge vif.cb_tb);
        else
            repeat(req.valid_interval) @(posedge vif.cb_tb);

        vif.cb_tb.is_data_in  <= req.is_data_in;
        vif.cb_tb.is_valid_in <= req.is_valid_in;
        vif.cb_tb.is_end_in   <= req.is_end_in;

        // Wait clk if busy is active.
        @(posedge vif.cb_tb iff(vif.cb_tb.is_busy_out!=`IMAGE_PIPE_BUSY_ACTIVE));

    endtask: drive_sig

endclass: image_pipe_driver

`endif
