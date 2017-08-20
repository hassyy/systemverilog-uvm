`ifndef __REG_CPU_ENV__
`define __REG_CPU_ENV__

`include "reg_cpu_common.svh"
`include "reg_cpu_agent.sv"
`include "reg_cpu_reg_predictor.sv"

class reg_cpu_env extends uvm_env;

    reg_cpu_agent agent;
    reg_cpu_reg_predictor reg_predictor;

    `uvm_component_utils(reg_cpu_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        agent = reg_cpu_agent::type_id::create("agent", this);
        reg_predictor = reg_cpu_reg_predictor::type_id::create(.name("reg_predictor"), .parent(this));

        `uvm_info(get_full_name( ), "Build stage complete.", UVM_LOW)
    endfunction : build_phase

endclass: reg_cpu_env

`endif

