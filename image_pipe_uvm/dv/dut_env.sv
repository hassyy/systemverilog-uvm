`ifndef __DUT_ENV__
    `define __DUT_ENV__

`include "common_header.svh"
`include "image_pipe_env.sv"
`include "image_pipe_scoreboard.sv"


class dut_env extends uvm_env;

    image_pipe_env penv_in;
    image_pipe_env penv_out;
    image_pipe_scoreboard sb;

    reg_cpu_agent reg_agent;
    reg_cpu_env reg_env;
    dut_reg_block reg_block;

    `uvm_component_utils(dut_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        uvm_config_db#(int)::set(this, "penv_in.agent", "is_active", UVM_ACTIVE);
        uvm_config_db#(int)::set(this, "penv_in.agent", "is_busy_active", UVM_PASSIVE);
        uvm_config_db#(int)::set(this, "penv_out.agent", "is_active", UVM_PASSIVE);
        uvm_config_db#(int)::set(this, "penv_out.agent", "is_busy_active", UVM_ACTIVE);

        uvm_config_db#(string)::set(this, "penv_in.agent.monitor", "monitor_intf", "in_intf");
        uvm_config_db#(string)::set(this, "penv_out.agent.monitor", "monitor_intf", "out_intf");

        penv_in = image_pipe_env::type_id::create("penv_in", this);
        penv_out = image_pipe_env::type_id::create("penv_out", this);
        sb = image_pipe_scoreboard::type_id::create("sb", this);

        reg_env = reg_cpu_env::type_id::create("reg_env", this);
        reg_env = reg_cpu_env::type_id::create("reg_env", this);
        reg_predictor = reg_cpu_reg_predictor::type_id::create(.name("reg_predictor"), .parent(this));

        `uvm_info(get_full_name( ), "Build stage complete.", UVM_LOW)
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        penv_in.agent.monitor.item_collected_port.connect(sb.input_data_collected.analysis_export);
        penv_out.agent.monitor.item_collected_port.connect(sb.output_data_collected.analysis_export);

        if (reg_block.get_parnet()==null)
            reg_block.reg_map.set_sequencer(.sequencer(reg_agent.))

        `uvm_info(get_full_name( ), "Build stage complete.", UVM_LOW)
    endfunction: connect_phase

endclass : dut_env

`endif
