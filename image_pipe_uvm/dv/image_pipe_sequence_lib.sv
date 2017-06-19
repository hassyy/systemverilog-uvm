`ifndef __IMAGE_PIPE_SEQUENCE_LIB__
    `define __IMAGE_PIPE_SEQUENCE_LIB__

`include "common_header.svh"
`include "image_pipe_data.sv"


class random_sequence extends uvm_sequence #(image_pipe_data);
    `uvm_object_utils(random_sequence)

    function new(string name = "random_sequence");
        super.new(name);
    endfunction: new

    virtual task body( );
        `uvm_do(req);
    endtask: body

endclass: random_sequence

class data0_sequence extends uvm_sequence #(image_pipe_data);
     `uvm_object_utils(data0_sequence)

    function new(string name = "data0_sequence");
        super.new(name);
    endfunction: new

    virtual task body( );
        `uvm_do_with(req, {req.is_data_in == 32'h00000000;})
    endtask: body

endclass: data0_sequence

class data1_sequence extends uvm_sequence #(image_pipe_data);
    `uvm_object_utils(data1_sequence)

    function new(string name = "data1_sequence");
        super.new(name);
    endfunction : new

    virtual task body();
        req = image_pipe_data::type_id::create("req");
        start_item(req);
        assert(req.randomize( ) with {is_data_in == 32'hffffffff;});
        finish_item(req);
    endtask: body
endclass: data1_sequence

class many_random_sequence extends uvm_sequence #(image_pipe_data);
    rand int loop;
    constraint limit {loop inside {[5:10]};}

    `uvm_object_utils(many_random_sequence)

    function new(string name = "many_random_sequence");
        super.new(name);
    endfunction: new

    virtual task body( );
        for(int i=0; i<loop; i++) begin
            `uvm_do(req);
        end
    endtask : body

endclass : many_random_sequence

`endif
