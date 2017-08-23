`ifndef __IMAGE_PIPE_BUSY_DRIVER__
    `define __IMAGE_PIPE_BUSY_DRIVER__

`include "image_pipe_define.svh"
`include "image_pipe_data.sv"


class image_pipe_busy_driver#(int DW_IN, int DW_OUT) extends uvm_driver #(image_pipe_data #(DW_IN, DW_OUT));
    // Declare local virtual interface to drive signals.
    virtual image_pipe_if #(.DW_IN(DW_IN), .DW_OUT(DW_OUT)) vif;

    // Factory registration.
    `uvm_component_param_utils(image_pipe_busy_driver#(DW_IN, DW_OUT))

    // Madatory.
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    // Mandatory. vif is set to the actual
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // You must set generic params for virtual interface, or you'll have illegal assignment error.
        if (!uvm_config_db#(virtual image_pipe_if#(.DW_IN(DW_IN), .DW_OUT(DW_OUT)))::get(this, "", "out_intf", vif))
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name( ), ".vif"})
        `uvm_info(get_full_name( ), "BUILD_PHASE done.", UVM_LOW)
    endfunction

    virtual task run_phase(uvm_phase phase);
        fork
            reset();
            get_and_drive();
        join
    endtask: run_phase

    virtual task reset();
        forever begin
            wait(vif.rst_n==`IMAGE_PIPE_RESET_ACTIVE);
            `uvm_info(get_type_name(), "DO_RESET", UVM_LOW)
            while (vif.rst_n==`IMAGE_PIPE_RESET_ACTIVE) begin
                vif.cb_tb.ipm_busy_in <= `IMAGE_PIPE_BUSY_ACTIVE;
                 @(vif.cb_tb);
            end
        end
    endtask: reset

    virtual task get_and_drive( );
        forever begin
            @(posedge vif.rst_n);
            while (vif.rst_n != `IMAGE_PIPE_RESET_ACTIVE) begin
                seq_item_port.get_next_item(req);
                drive_busy(req);
                seq_item_port.item_done( );
            end
        end
    endtask: get_and_drive

    virtual task drive_busy(image_pipe_data#(DW_IN, DW_OUT) req);
        $timeformat(-9, 3, "ns" ,10);

        // Here, you must use vif with clocking block.
        // Or you cannot see the skew as expected.
        if (vif.rst_n == `IMAGE_PIPE_RESET_ACTIVE)
            // Wait during reset
            @(posedge vif.cb_tb);
        else begin
            // Drive busy
            if (req.busy_assert_cycle>0) begin
                vif.cb_tb.ipm_busy_in <= `IMAGE_PIPE_BUSY_ACTIVE;
                repeat(req.busy_assert_cycle) @(posedge vif.cb_tb);
                //$display($sformatf("[%t][%s]", $stime(), get_full_name()));
            end
            else
                @(posedge vif.cb_tb);

            if (req.busy_negate_cycle>0) begin
                vif.cb_tb.ipm_busy_in <= !`IMAGE_PIPE_BUSY_ACTIVE;
                repeat(req.busy_negate_cycle) @(posedge vif.cb_tb);
            end
            else
                @(posedge vif.cb_tb);
        end
    endtask: drive_busy

endclass: image_pipe_busy_driver

`endif
