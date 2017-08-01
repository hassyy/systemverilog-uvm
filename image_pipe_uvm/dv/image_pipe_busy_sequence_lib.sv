`ifndef __IMAGE_PIPE_BUSY_SEQUENCE_LIB__
    `define __IMAGE_PIPE_BUSY_SEQUENCE_LIB__

`include "common_header.svh"
`include "image_pipe_data.sv"

class image_pipe_normal_busy_sequence extends uvm_sequence #(image_pipe_data#());

    // Factory registration
    `uvm_object_param_utils(image_pipe_normal_busy_sequence)

    // Need to declare new here.
    function new(string name = "image_pipe_normal_busy_sequence");
        super.new(name);
    endfunction: new

    //  Your sequence here:
    //  This is normal_sequence, so just randomize the timing parameters.
    //  You need to give the constraint from your test, or default constraints are used.
    virtual task body();
        // Free running busy timing parameter generation.
        `uvm_info(get_full_name, "START body()", UVM_LOW)
        forever begin
            // Randomize req (=image_pipe_data) without runtime constraints.
            `uvm_do(req);
        end
    endtask : body

endclass : image_pipe_normal_busy_sequence

`endif
