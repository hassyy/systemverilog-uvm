`ifndef __IMAGE_PIPE_DRIVER__
`define __IMAGE_PIPE_DRIVER__


`include "image_pipe_common.svh"


class image_pipe_driver #(int DW_IN, int DW_OUT)
    extends uvm_driver #(image_pipe_data#(DW_IN, DW_OUT));

    // You must declare vif with generic parameter, or you'll have illegal assingment error.
    virtual image_pipe_if #(.DW_IN(DW_IN), .DW_OUT(DW_OUT)) vif;

    `uvm_component_param_utils(image_pipe_driver#(DW_IN, DW_OUT))


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        if (!uvm_config_db#(virtual image_pipe_if#(.DW_IN(DW_IN), .DW_OUT(DW_OUT)))::get(this, "", "in_intf", vif))
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name( ), ".vif"})
    endfunction

    virtual task run_phase(uvm_phase phase);
        fork
            reset();
            get_and_drive();
        join
            `uvm_info(get_type_name( ), "RUN_PHASE done.", UVM_LOW)
    endtask: run_phase

    virtual task reset( );
        forever begin
            wait(vif.rst_n==`IMAGE_PIPE_RESET_ACTIVE);
            `uvm_info(get_type_name(), "DO_RESET", UVM_LOW)
            while (vif.rst_n==`IMAGE_PIPE_RESET_ACTIVE) begin
                vif.cb_tb.image_pipe_data_in  <= '0;
                vif.cb_tb.image_pipe_valid_in <= '0;
                vif.cb_tb.image_pipe_end_in   <= '0;
                @(vif.cb_tb);
            end
        end
    endtask: reset

    virtual task get_and_drive( );
        forever begin
            @(posedge vif.rst_n);
            while (vif.rst_n == `IMAGE_PIPE_RESET_INACTIVE) begin
                seq_item_port.get_next_item(req);
                drive_sig(req);
                seq_item_port.item_done( );
            end
        end
    endtask: get_and_drive

    virtual task drive_sig(image_pipe_data#(DW_IN, DW_OUT) req);

        // Wait during reset
        while (vif.rst_n==`IMAGE_PIPE_RESET_ACTIVE) @(posedge vif.cb_tb);

        if (req.first_data_flag)
            repeat(req.wait_before_transmit) @(posedge vif.cb_tb);
        else
        if (req.last_data_flag) begin
            vif.cb_tb.image_pipe_valid_in <= `IMAGE_PIPE_VALID_INACTIVE;
            repeat(req.wait_before_end) @(posedge vif.cb_tb);
        end
        else begin
            vif.cb_tb.image_pipe_valid_in <= `IMAGE_PIPE_VALID_INACTIVE;
            repeat(req.valid_interval) @(posedge vif.cb_tb);
        end

        vif.cb_tb.image_pipe_data_in  <= req.image_pipe_data_in;
        vif.cb_tb.image_pipe_valid_in <= req.image_pipe_valid_in;
        vif.cb_tb.image_pipe_end_in   <= req.image_pipe_end_in;
        @(posedge vif.cb_tb);

        // Wait clk if busy is active.
        while (vif.cb_tb.image_pipe_busy_out==`IMAGE_PIPE_BUSY_ACTIVE)
            @(posedge vif.cb_tb);

    endtask: drive_sig

endclass: image_pipe_driver

`endif
