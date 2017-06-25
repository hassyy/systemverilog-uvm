
`ifndef __IMAGE_PIPE_ENV__
    `define __IMAGE_PIPE_ENV__

`include "common_header.svh"
`include "image_pipe_agent.sv"


class image_pipe_env extends uvm_env;

    image_pipe_agent#(32, 32) agent;

    `uvm_component_utils(image_pipe_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        agent = image_pipe_agent#(32, 32)::type_id::create("agent", this);

        `uvm_info(get_full_name( ), "Build stage complete.", UVM_LOW)
    endfunction : build_phase

endclass : image_pipe_env

`endif
