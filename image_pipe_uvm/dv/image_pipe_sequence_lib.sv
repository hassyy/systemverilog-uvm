`ifndef __IMAGE_PIPE_SEQUENCE_LIB__
    `define __IMAGE_PIPE_SEQUENCE_LIB__

`include "common_header.svh"
`include "image_pipe_data.sv"

class many_random_sequence extends uvm_sequence #(image_pipe_data);
    rand int loop;
    constraint limit {loop inside {[5:10]};}

    `uvm_object_utils(many_random_sequence)

    function new(string name = "many_random_sequence");
        super.new(name);
    endfunction: new

    virtual task body( );
        for(int i=0; i<loop; i++) begin
            `uvm_do_with(req, {
                req.is_valid_in == 1;
                req.is_end_in   == 0;
                });
        end
        // End for 1 cycle
        `uvm_do_with(req, {
            req.is_data_in  == '0;
            req.is_valid_in == '0;
            req.is_end_in   == 1;
            });
        `uvm_do_with(req, {
            req.is_data_in  == '0;
            req.is_valid_in == '0;
            req.is_end_in   == 0;
            });
    endtask : body

endclass : many_random_sequence

`endif
