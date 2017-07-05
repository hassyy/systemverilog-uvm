`ifndef __IMAGE_PIPE_BUSY_SEQUENCE_LIB__
    `define __IMAGE_PIPE_BUSY_SEQUENCE_LIB__

`include "common_header.svh"
`include "image_pipe_data.sv"

class normal_busy_sequence extends uvm_sequence #(image_pipe_data#());
    rand int loop;
    constraint default_constraint {
        soft loop inside {[5:10]};
    }

    `uvm_object_param_utils(normal_busy_sequence)

    function new(string name = "normal_busy_sequence");
        super.new(name);
    endfunction: new

    virtual task body( );
        forever begin
            `uvm_do_with(req, {req.im_busy_In==1; });
            `uvm_do_with(req, {req.im_busy_In==0; });
        end
    endtask : body

endclass : normal_busy_sequence

`endif
