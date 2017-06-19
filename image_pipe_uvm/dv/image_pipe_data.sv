`ifndef __IMAGE_DATA__
    `define __IMAGE_DATA__

`include "common_header.svh"

class image_pipe_data extends uvm_sequence_item;
    rand bit [31:0] is_data_in;
    rand bit        is_valid_in;
    rand bit        is_end_in;
    rand bit        is_busy_out;
    rand bit [31:0] im_data_out;
    rand bit        im_valid_out;
    rand bit        im_end_out;
    rand bit        im_busy_in;
    rand int delay;

    constraint timing {delay inside {[0:5]};}

    `uvm_object_utils_begin(image_pipe_data)
        `uvm_field_int(is_data_in, UVM_DEFAULT)
        `uvm_field_int(is_valid_in, UVM_DEFAULT)
        `uvm_field_int(is_end_in, UVM_DEFAULT)
        `uvm_field_int(is_busy_out, UVM_DEFAULT)
        `uvm_field_int(im_data_out, UVM_DEFAULT)
        `uvm_field_int(im_valid_out, UVM_DEFAULT)
        `uvm_field_int(im_end_out, UVM_DEFAULT)
        `uvm_field_int(im_busy_in, UVM_DEFAULT)
        `uvm_field_int(delay, UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "image_data");
        super.new(name);
    endfunction: new

    virtual task displayAll();
        `uvm_info("DP", $sformatf("is_data_in=%0h is_valid_in=%0b is_end_in=%0h is_busy_out=%0h
                    im_data_out=%0h im_valid_out=%0h im_end_out=%0h im_busy_in=%0h delay=%0d"
                    , is_data_in, is_valid_in, is_end_in, is_busy_out
                    , im_data_out, im_valid_out, im_end_out, im_busy_in, delay)
                    , UVM_LOW)
    endtask: displayAll
endclass: image_pipe_data

`endif
