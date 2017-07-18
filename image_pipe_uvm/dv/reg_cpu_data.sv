`ifndef __REG_CPU_DATA__
    `define __REG_CPU_DATA__

`include "common_header.svh"

class reg_cpu_data #(int AW=32, int DW=32) extends uvm_sequence_item;

    typedef enum bit {WRITE, READ} t_reg_cpu_cmd;
    rand t_reg_cpu_cmd reg_cpu_cmd;

    rand bit reg_cpu_cs;
    rand bit [AW-1:0] reg_cpu_addr;
    rand bit [DW-1:0] reg_cpu_wr_data;
    rand bit [DW-1:0] reg_cpu_rd_data;
    rand bit reg_cpu_we;
    rand bit reg_cpu_re;
    rand bit reg_cpu_wack;
    rand bit reg_cpu_rdv;

    // Timing parameter
    rand int cmd_interval;

    // Default constraint
    constraint ct_default_timing {
        soft cmd_interval==0;
    }

    // Factory registration.
    `uvm_object_utils_begin(reg_cpu_data#(AW, DW))
        `uvm_field_enum(t_reg_cpu_cmd, reg_cpu_cmd, UVM_DEFAULT)

        `uvm_field_int(reg_cpu_cs, UVM_DEFAULT)
        `uvm_field_int(reg_cpu_addr, UVM_DEFAULT)
        `uvm_field_int(reg_cpu_wr_data, UVM_DEFAULT)
        `uvm_field_int(reg_cpu_rd_data, UVM_DEFAULT)
        `uvm_field_int(reg_cpu_we, UVM_DEFAULT)
        `uvm_field_int(reg_cpu_wack, UVM_DEFAULT)
        `uvm_field_int(reg_cpu_re, UVM_DEFAULT)
        `uvm_field_int(reg_cpu_rdv, UVM_DEFAULT)
        // Timing parameter
        `uvm_field_int(cmd_interval, UVM_DEFAULT)
    `uvm_object_utils_end

endclass: reg_cpu_data

`endif



