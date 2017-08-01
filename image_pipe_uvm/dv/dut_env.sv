`ifndef __DUT_ENV__
    `define __DUT_ENV__

`include "common_header.svh"
`include "reset_agent.sv"
`include "image_pipe_env.sv"
`include "image_pipe_scoreboard.sv"
`include "reg_cpu_env.sv"
`include "dut_reg_block.sv"
`include "image_pipe_vsequencer.sv"


class dut_env extends uvm_env;

    reset_agent reset_agt;

    image_pipe_env penv_in;
    image_pipe_env penv_out;
    image_pipe_scoreboard sb;

    reg_cpu_env reg_env;
    dut_reg_block reg_block;

    image_pipe_vsequencer v_seqr;

    `uvm_component_utils(dut_env)

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Configuration
        uvm_config_db#(int)::set(this, "reset_agt", "is_active", UVM_ACTIVE);

        uvm_config_db#(int)::set(this, "penv_in.agent", "is_active", UVM_ACTIVE);
        uvm_config_db#(int)::set(this, "penv_in.agent", "is_busy_active", UVM_PASSIVE);
        uvm_config_db#(int)::set(this, "penv_out.agent", "is_active", UVM_PASSIVE);
        uvm_config_db#(int)::set(this, "penv_out.agent", "is_busy_active", UVM_ACTIVE);

        uvm_config_db#(string)::set(this, "penv_in.agent.monitor", "monitor_intf", "in_intf");
        uvm_config_db#(string)::set(this, "penv_out.agent.monitor", "monitor_intf", "out_intf");

        // Instantiation
        reset_agt = reset_agent::type_id::create("reset_agt", this);

        penv_in = image_pipe_env::type_id::create("penv_in", this);
        penv_out = image_pipe_env::type_id::create("penv_out", this);
        sb = image_pipe_scoreboard::type_id::create("sb", this);

        reg_env = reg_cpu_env::type_id::create("reg_env", this);

        v_seqr = image_pipe_vsequencer::type_id::create("v_seqr", this);

        `uvm_info(get_full_name( ), "BUILD_PHASE done.", UVM_LOW)
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        penv_in.agent.monitor.item_collected_port.connect(sb.input_data_collected.analysis_export);
        penv_out.agent.monitor.item_collected_port.connect(sb.output_data_collected.analysis_export);

        // For register abstruction
        if (reg_block.get_parent()==null)
            reg_block.reg_map.set_sequencer(
                .sequencer(reg_env.agent.sequencer),
                .adapter(reg_env.agent.adapter)
            );

        reg_env.reg_predictor.map = reg_block.reg_map;
        reg_env.reg_predictor.adapter = reg_env.agent.adapter;

        // Connect virtual sequencer to non-virtual sequencer.
        // If not, you'll have NULL_POINTER_EXCEPTION...osz
        v_seqr.image_pipe_seqr      = penv_in.agent.sequencer;
        v_seqr.image_pipe_busy_seqr = penv_out.agent.busy_sequencer;
        v_seqr.reg_cpu_seqr         = reg_env.agent.sequencer;
        v_seqr.reset_seqr           = reset_agt.sequencer;

        `uvm_info(get_full_name( ), "CONNECT_PHASE done.", UVM_LOW)
    endfunction: connect_phase

endclass : dut_env

`endif
