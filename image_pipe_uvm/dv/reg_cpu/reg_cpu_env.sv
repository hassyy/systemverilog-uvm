`ifndef __REG_CPU_ENV__
`define __REG_CPU_ENV__

`include "reg_cpu_common.svh"

class reg_cpu_env#(int AW, int DW) extends uvm_env;

    reg_cpu_agent#(AW, DW) agent;
    //reg_cpu_reg_predictor reg_predictor;
    uvm_reg_predictor#(reg_cpu_data#(AW,DW)) reg_predictor;

    `uvm_component_param_utils(reg_cpu_env#(AW, DW))

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        agent = reg_cpu_agent#(AW, DW)::type_id::create("agent", this);
        //reg_predictor = reg_cpu_reg_predictor::type_id::create(.name("reg_predictor"), .parent(this));
        reg_predictor = uvm_reg_predictor#(reg_cpu_data#(AW,DW))::type_id::create(.name("reg_predictor"), .parent(this));

        `uvm_info(get_full_name( ), "Build stage complete.", UVM_LOW)
    endfunction : build_phase

endclass: reg_cpu_env

`endif

