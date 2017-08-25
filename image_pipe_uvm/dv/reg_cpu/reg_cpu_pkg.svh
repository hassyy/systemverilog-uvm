`ifndef __REG_CPU_PKG__
`define __REG_CPU_PKG__

package reg_cpu_pkg;

    `include "reg_cpu_common.svh"

    `include "reg_cpu_data.sv"
    `include "reg_cpu_driver.sv"
    //`include "reg_cpu_monitor.sv"
    `include "reg_cpu_sequencer.sv"
    //`include "reg_cpu_scoreboard.sv"
    `include "reg_cpu_reg_adapter.sv"
    `include "reg_cpu_agent.sv"
    `include "reg_cpu_env.sv"

endpackage

`endif
