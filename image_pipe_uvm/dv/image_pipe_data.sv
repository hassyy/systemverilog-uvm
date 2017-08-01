`ifndef __IMAGE_DATA__
`define __IMAGE_DATA__

`include "common_header.svh"


class image_pipe_data #(int DW_IN=32, int DW_OUT=32) extends uvm_sequence_item;

    rand bit [DW_IN-1:0] is_data_in;
    rand bit        is_valid_in;
    rand bit        is_end_in;
    rand bit        is_busy_out;
    rand bit [DW_OUT-1:0] im_data_out;
    rand bit        im_valid_out;
    rand bit        im_end_out;
    rand bit        im_busy_in;

    // Control Parameter
    rand bit first_data_flag;
    rand bit last_data_flag;

    // Timing Parameter
    // TODO: Separate into other files
    rand int wait_before_transmit;
    rand int valid_interval;
    rand int wait_before_end;

    rand int wait_before_busy_start;
    rand int busy_assert_cycle;
    rand int busy_negate_cycle;


    // Default constraint
    constraint ct_default_image_pipe {
        soft is_valid_in==0;
        soft is_end_in==0;
        soft is_busy_out==0;
    }

    constraint ct_default_flag {
        soft first_data_flag==0;
        soft last_data_flag==0;
    }

    constraint ct_default_timing {
        soft wait_before_transmit==0;
        soft valid_interval==0;
        soft wait_before_end==0;

        soft wait_before_busy_start==0;
        soft busy_assert_cycle==0;
        soft busy_negate_cycle==0;
    }

    `uvm_object_utils_begin(image_pipe_data#(DW_IN, DW_OUT))
        `uvm_field_int(is_data_in, UVM_DEFAULT)
        `uvm_field_int(is_valid_in, UVM_DEFAULT)
        `uvm_field_int(is_end_in, UVM_DEFAULT)
        `uvm_field_int(is_busy_out, UVM_DEFAULT)
        `uvm_field_int(im_data_out, UVM_DEFAULT)
        `uvm_field_int(im_valid_out, UVM_DEFAULT)
        `uvm_field_int(im_end_out, UVM_DEFAULT)
        `uvm_field_int(im_busy_in, UVM_DEFAULT)
        // Control Flag
        `uvm_field_int(first_data_flag, UVM_DEFAULT)
        `uvm_field_int(last_data_flag, UVM_DEFAULT)
        // Timing Parameter
        `uvm_field_int(wait_before_transmit, UVM_DEFAULT)
        `uvm_field_int(valid_interval, UVM_DEFAULT)
        `uvm_field_int(wait_before_end, UVM_DEFAULT)
        `uvm_field_int(wait_before_busy_start, UVM_DEFAULT)
        `uvm_field_int(busy_assert_cycle, UVM_DEFAULT)
        `uvm_field_int(busy_negate_cycle, UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "image_pipe_data");
        super.new(name);
    endfunction: new

    virtual task display_busy();
        `uvm_info(" BUSY"
                    , $sformatf("wait_before:%3d, assert:%3d, negate:%3d"
                    , wait_before_busy_start, busy_assert_cycle, busy_negate_cycle
                    ), UVM_LOW);
    endtask: display_busy

    virtual task displayAll();
        `uvm_info("DP", $sformatf("is_data_in=%0h is_valid_in=%0b is_end_in=%0h is_busy_out=%0h
                    im_data_out=%0h im_valid_out=%0h im_end_out=%0h im_busy_in=%0h"
                    , is_data_in, is_valid_in, is_end_in, is_busy_out
                    , im_data_out, im_valid_out, im_end_out, im_busy_in)
                    , UVM_LOW)
    endtask: displayAll
endclass: image_pipe_data

`endif
