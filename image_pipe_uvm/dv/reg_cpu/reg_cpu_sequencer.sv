`ifndef __REG_CPU_SEQUENCER__
`define __REG_CPU_SEQUENCER__

`include "reg_cpu_common.svh"

class reg_cpu_sequencer#(int AW, int DW) extends uvm_sequencer #(reg_cpu_data#(AW, DW));

    // Mandatory: Factory registration
    `uvm_sequencer_param_utils(reg_cpu_sequencer#(AW, DW));


    // Mandatory
    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

endclass: reg_cpu_sequencer

`endif
