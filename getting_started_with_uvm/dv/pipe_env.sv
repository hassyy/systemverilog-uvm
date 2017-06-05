
`ifndef __PIPE_ENV__
    `define __PIPE_ENV__

//`include "common_header.svh"
//`include "pipe_agent.sv"


class pipe_env extends uvm_env;

    pipe_agent agent;

    `uvm_component_utils(pipe_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    // function void build_pahse(uvm_phase phase);
    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        agent = pipe_agent::type_id::create("agent", this);

        `uvm_info(get_full_name( ), "Build stage complete.", UVM_LOW)
    // endfunction : build_pahse
    endfunction : build_phase

endclass : pipe_env

`endif
