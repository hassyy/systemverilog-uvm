`ifndef __REG_CPU_AGENT__
`define __REG_CPU_AGENT__

`include "reg_cpu_common.svh"

`include "reg_cpu_data.sv"
`include "reg_cpu_sequencer.sv"
`include "reg_cpu_driver.sv"
`include "dut_reg_adapter.sv"

class reg_cpu_agent extends uvm_agent;
    `uvm_component_utils(reg_cpu_agent)

    reg_cpu_sequencer sequencer;
    reg_cpu_driver driver;
    dut_reg_adapter adapter;

    //reg_cpu_monitor() monitor;  // TODO

    function new(string name, uvm_component parent) ;
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);


        sequencer = reg_cpu_sequencer::type_id::create(.name("sequencer"), .parent(this));
        driver = reg_cpu_driver::type_id::create(.name("driver"), .parent(this));
        adapter = dut_reg_adapter::type_id::create(.name("adapter"), .parent(this));

        `uvm_info(get_full_name(), "BUILD_PHASE_DONE", UVM_LOW)
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        driver.seq_item_port.connect(sequencer.seq_item_export);

        `uvm_info(get_full_name(), "CONNECT_PHASE_DONE", UVM_LOW)
    endfunction: connect_phase

endclass

`endif
