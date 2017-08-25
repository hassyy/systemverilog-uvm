`ifndef __REG_CPU_AGENT__
`define __REG_CPU_AGENT__

`include "reg_cpu_common.svh"


class reg_cpu_agent#(int AW, int DW) extends uvm_agent;
    `uvm_component_param_utils(reg_cpu_agent#(AW, DW))

    reg_cpu_sequencer#(AW, DW) sequencer;
    reg_cpu_driver#(AW, DW) driver;
    reg_cpu_monitor#(AW, DW) monitor;
    reg_cpu_scoreboard#(AW, DW) sb;
    reg_cpu_reg_adapter#(AW, DW) adapter;

    //reg_cpu_monitor() monitor;  // TODO

    function new(string name, uvm_component parent) ;
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);


        sequencer = reg_cpu_sequencer#(DW, DW)::type_id::create(.name("sequencer"), .parent(this));
        driver = reg_cpu_monitor#(AW, DW)::type_id::create(.name("monitor"), .parent(this));
        monitor = reg_cpu_driver#(AW, DW)::type_id::create(.name("driver"), .parent(this));
        adapter = reg_cpu_reg_adapter#(AW, DW)::type_id::create(.name("adapter"), .parent(this));

        `uvm_info(get_full_name(), "BUILD_PHASE done", UVM_LOW)
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);

        // Connect scoreboard and monitors
        monitor.ap.connect(sb.af.analysis_export);

        `uvm_info(get_full_name(), "CONNECT_PHASE done", UVM_LOW)
    endfunction: connect_phase

endclass

`endif
