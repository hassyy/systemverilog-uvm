`ifndef __REG_CPU_DATA__
`define __REG_CPU_DATA__

`include "reg_cpu_common.svh"


class reg_cpu_data #(int AW=32, int DW=32) extends uvm_sequence_item;

    typedef enum bit {WRITE, READ} t_reg_cpu_cmd;
    rand t_reg_cpu_cmd reg_cpu_cmd;

    rand bit reg_cpu_cs;
    rand bit [AW-1:0] reg_cpu_addr;
    rand bit [DW-1:0] reg_cpu_data_wr;
    rand bit [DW-1:0] reg_cpu_data_rd;
    rand bit reg_cpu_we;
    rand bit reg_cpu_re;
    rand bit reg_cpu_wack;
    rand bit reg_cpu_rdv;

    // Control Parameter
    rand bit first_flag;
    rand bit last_flag;

    // Timing parameter
    rand int wait_before_start;
    rand int cmd_interval;

    // Default constraint
    constraint ct_default_timing {
        soft wait_before_start==10;
        soft cmd_interval==0;
    }

    // Factory registration.
    `uvm_object_utils_begin(reg_cpu_data#(AW, DW))
        `uvm_field_enum(t_reg_cpu_cmd, reg_cpu_cmd, UVM_DEFAULT)

        `uvm_field_int(reg_cpu_cs, UVM_DEFAULT)
        `uvm_field_int(reg_cpu_addr, UVM_DEFAULT)
        `uvm_field_int(reg_cpu_data_wr, UVM_DEFAULT)
        `uvm_field_int(reg_cpu_data_rd, UVM_DEFAULT)
        `uvm_field_int(reg_cpu_we, UVM_DEFAULT)
        `uvm_field_int(reg_cpu_wack, UVM_DEFAULT)
        `uvm_field_int(reg_cpu_re, UVM_DEFAULT)
        `uvm_field_int(reg_cpu_rdv, UVM_DEFAULT)
        // Control parameter
        `uvm_field_int(first_flag, UVM_DEFAULT)
        `uvm_field_int(last_flag, UVM_DEFAULT)
        // Timing parameter
        `uvm_field_int(wait_before_start, UVM_DEFAULT)
        `uvm_field_int(cmd_interval, UVM_DEFAULT)
    `uvm_object_utils_end

endclass: reg_cpu_data

`endif



