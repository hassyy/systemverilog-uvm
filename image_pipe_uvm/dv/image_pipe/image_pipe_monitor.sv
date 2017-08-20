`ifndef __IMAGE_PIPE_MONITOR__
    `define __IMAGE_PIPE_MONITOR__

`include "image_pipe_data.sv"


class image_pipe_monitor #(int DW_IN, int DW_OUT) extends uvm_monitor;

    virtual image_pipe_if #(.DW_IN(DW_IN), .DW_OUT(DW_OUT)) vif;
    string monitor_intf;
    int num_collected_data;


    uvm_analysis_port #(image_pipe_data#(DW_IN, DW_OUT)) ap;
    image_pipe_data #(DW_IN, DW_OUT) data_collected;
    image_pipe_data #(DW_IN, DW_OUT) data_clone;

    `uvm_component_param_utils(image_pipe_monitor#(DW_IN, DW_OUT))

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // This string is used to identify the vif set later.
        if (!uvm_config_db#(string)::get(this, "", "monitor_intf", monitor_intf))
            `uvm_fatal("NOSTRING", {"Need interface name for: ", get_full_name( ), ".monitor_intf"})

        `uvm_info(get_type_name( ), $sformatf("INTERFACE USED = %0s", monitor_intf), UVM_LOW)

        // This set the vif with the string previously set.
        if (!uvm_config_db#(virtual image_pipe_if#(.DW_IN(DW_IN), .DW_OUT(DW_OUT)))::get(this, "", monitor_intf, vif))
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name( ), ".vif"})

        // We need to instantiate analysys_port by new. It cannot be registerd to UVM Factory.
        ap = new("ap", this);
        data_collected = image_pipe_data#(DW_IN, DW_OUT)::type_id::create("data_collected");
        data_clone = image_pipe_data#(DW_IN, DW_OUT)::type_id::create("data_clone");

        `uvm_info(get_full_name(), "BUILD_PHASE done", UVM_LOW)
    endfunction : build_phase


    // Main process of monitor
    virtual task run_phase(uvm_phase phase);
        collect_data( );
    endtask: run_phase


    virtual task collect_data( );
        forever begin
            // Wait until the data collecting timing
            // We must use clocking block for monitor to have proper data collect timing.

            //
            if (monitor_intf=="in_intf") begin
                wait(vif.cb_mon.is_valid_in & !vif.cb_mon.is_busy_out);
                data_collected.is_data_in  = vif.cb_mon.is_data_in;
                data_collected.is_valid_in = vif.cb_mon.is_valid_in;
                data_collected.is_end_in   = vif.cb_mon.is_end_in;
            end
            else
            if (monitor_intf=="out_intf") begin
                wait(vif.cb_mon.im_valid_out & !vif.cb_mon.im_busy_in);
                data_collected.im_data_out  = vif.cb_mon.im_data_out;
                data_collected.im_valid_out = vif.cb_mon.im_valid_out;
                data_collected.im_end_out   = vif.cb_mon.im_end_out;
            end

            // We must clone the data to send it to analysis port.
            $cast(data_clone, data_collected.clone( ));

            // Send the collected data on analisys port (to scoreboard)
            ap.write(data_clone);
            num_collected_data++;
            @(posedge vif.cb_mon);
        end
    endtask: collect_data


    virtual function void report_phase(uvm_phase phase);
        `uvm_info(  get_type_name()
                    , $sformatf("REPORT: COLLECTED PACKETS = %0d", num_collected_data)
                    , UVM_LOW
                    )
    endfunction : report_phase


endclass : image_pipe_monitor

`endif
