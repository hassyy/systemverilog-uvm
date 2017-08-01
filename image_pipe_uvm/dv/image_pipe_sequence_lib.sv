`ifndef __IMAGE_PIPE_SEQUENCE_LIB__
    `define __IMAGE_PIPE_SEQUENCE_LIB__

`include "common_header.svh"
`include "image_pipe_data.sv"

class image_pipe_simple_sequence extends uvm_sequence #(image_pipe_data#());
    rand int loop;
    constraint default_constraint {
        soft loop inside {[5:10]};
    }

    `uvm_object_param_utils(image_pipe_simple_sequence)

    function new(string name = "image_pipe_simple_sequence");
        super.new(name);
    endfunction: new

    // IMAGE_PIPE sequence HERE:
    virtual task body();

        `uvm_info(get_full_name, "START body()", UVM_LOW)

        for(int i=0; i<loop; i++) begin
            if (i==loop-1) begin
                `uvm_do_with(req, {
                    req.last_data_flag== 1;
                    req.is_valid_in == 1;
                    });
            end
            else
            if (i==0) begin
                `uvm_do_with(req, {
                    req.first_data_flag==1;
                    req.is_valid_in == 1;
                    });
            end
            else begin
                `uvm_do_with(req, {
                    req.is_valid_in == 1;
                    });
            end
        end
        // End for 1 cycle
        `uvm_do_with(req, {
            req.last_data_flag==0;
            req.is_data_in  == '0;
            req.is_end_in   == 1;
            });
        `uvm_do_with(req, {
            req.is_data_in  == '0;
            req.is_end_in   == 0;
            });
    endtask : body

endclass : image_pipe_simple_sequence

`endif
