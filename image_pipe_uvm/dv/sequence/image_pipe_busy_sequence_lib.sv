`ifndef __IMAGE_PIPE_BUSY_SEQUENCE_LIB__
    `define __IMAGE_PIPE_BUSY_SEQUENCE_LIB__

`include "sequence_common.svh"


class image_pipe_normal_busy_sequence#(int DW_IN, int DW_OUT)
    extends uvm_sequence #(image_pipe_data#(DW_IN, DW_OUT));

    // Factory registration
    `uvm_object_param_utils(image_pipe_normal_busy_sequence#(DW_IN, DW_OUT))

    // Need to declare new here.
    function new(string name = "normal_busy_sequence");
        super.new(name);
    endfunction: new

    //  Your sequence here:
    //  This is normal_normal_sequence, so just randomize the timing parameters.
    //  You need to give the constraint from your test, or default constraints are used.
    virtual task body();
        // Free running busy timing parameter generation.
        forever begin
            // Randomize req (=image_pipe_data) without runtime constraints.
            `uvm_do(req);
        end
    endtask : body

endclass : image_pipe_normal_busy_sequence

`endif
