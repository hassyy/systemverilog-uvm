`ifndef __REG_CPU_PKG__
`define __REG_CPU_PKG__

package reg_cpu_pkg;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    `include "define.svh"

    `include "reg_cpu_data.sv"
    `include "reg_cpu_driver.sv"
    `include "reg_cpu_sequencer.sv"
    `include "reg_cpu_reg_predictor.sv"
    `include "reg_cpu_env.sv"
    `include "reg_cpu_sequence_lib.sv"

endpackage

`endif
