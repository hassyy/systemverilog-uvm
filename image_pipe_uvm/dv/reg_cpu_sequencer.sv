`ifndef __REG_CPU_SEQUENCER__
`define __REG_CPU_SEQUENCER__

`include "common_header.svh"
`include "reg_cpu_data.sv"

class reg_cpu_sequencer extends uvm_sequencer #(reg_cpu_data#());

    // Mandatory: Factory registration
    `uvm_sequencer_param_utils(reg_cpu_sequencer);


    // Mandatory
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

endclass: reg_cpu_sequencer

`endif
