`ifndef __DUT_ENV__
`define __DUT_ENV__

`include "dut_env_common.svh"


class dut_env extends uvm_env;

    localparam DW_IN  = `IMAGE_PIPE_DW_IN1;
    localparam DW_OUT = `IMAGE_PIPE_DW_OUT1;

    localparam AW = `REG_CPU_AW;
    localparam DW = `REG_CPU_DW;

    reset_agent rst_agent;
    image_pipe_env#(DW_IN, DW_OUT) ip_env_in;
    image_pipe_env#(DW_IN, DW_OUT) ip_env_out;

    // Scoreboad which will be connected to image_pipe_monitor
    image_pipe_scoreboard#(DW_IN, DW_OUT) sb;

    // reg_cpu
    reg_cpu_env reg_env;
    dut_reg_block reg_block;

    image_pipe_vsequencer#(DW_IN, DW_OUT) v_seqr;

    `uvm_component_utils(dut_env)


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Configuration
        uvm_config_db#(int)::set(this, "rst_agent", "is_active", UVM_ACTIVE);

        uvm_config_db#(int)::set(this, "ip_env_in.agent", "is_active", UVM_ACTIVE);
        uvm_config_db#(int)::set(this, "ip_env_in.agent", "image_pipe_busy_active", UVM_PASSIVE);
        uvm_config_db#(int)::set(this, "ip_env_out.agent", "is_active", UVM_PASSIVE);
        uvm_config_db#(int)::set(this, "ip_env_out.agent", "image_pipe_busy_active", UVM_ACTIVE);

        uvm_config_db#(string)::set(this, "ip_env_in.agent.monitor", "monitor_intf", "in_intf");
        uvm_config_db#(string)::set(this, "ip_env_out.agent.monitor", "monitor_intf", "out_intf");

        // Instantiation
        rst_agent = reset_agent::type_id::create("rst_agent", this);

        ip_env_in = image_pipe_env#(DW_IN, DW_OUT)::type_id::create("ip_env_in", this);
        ip_env_out = image_pipe_env#(DW_IN, DW_OUT)::type_id::create("ip_env_out", this);
        sb = image_pipe_scoreboard#(DW_IN, DW_OUT)::type_id::create("sb", this);

        reg_env = reg_cpu_env#(AW, DW)::type_id::create("reg_env", this);

        v_seqr = image_pipe_vsequencer#(DW_IN, DW_OUT)::type_id::create("v_seqr", this);

        `uvm_info(get_full_name( ), "BUILD_PHASE done.", UVM_LOW)
    endfunction: build_phase


    function void connect_phase(uvm_phase phase);

        // Connect scoreboard and monitors via
        ip_env_in.agent.monitor.ap.connect(sb.in_data_af.analysis_export);
        ip_env_out.agent.monitor.ap.connect(sb.out_data_af.analysis_export);

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
        v_seqr.image_pipe_seqr      = ip_env_in.agent.sequencer;
        v_seqr.image_pipe_busy_seqr = ip_env_out.agent.busy_sequencer;
        v_seqr.reg_cpu_seqr         = reg_env.agent.sequencer;
        v_seqr.reset_seqr           = rst_agent.sequencer;

        `uvm_info(get_full_name( ), "CONNECT_PHASE done.", UVM_LOW)
    endfunction: connect_phase

endclass : dut_env

`endif