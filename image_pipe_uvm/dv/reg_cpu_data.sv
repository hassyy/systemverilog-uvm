`ifndef __REG_CPU_DATA__
    `define __REG_CPU_DATA__

`include "common_header.svh"

class reg_cpu_data #(int AW=32, int DW=32) extends uvm_sequence_item;

    rand bit reg_cpu_cs;
    rand bit [AW-1:0] reg_cpu_addr;
    rand bit [DW-1:0] reg_cpu_wr_data;
    rand bit [DW-1:0] reg_cpu_rd_data;
    rand bit reg_cpu_we;
    rand bit reg_cpu_re;
    rand bit reg_cpu_rdv;

    // Timing parameter
    rand int wait_before_start;
    rand int addr_cmd_interval;
    rand int wait_before_next;

    // Default constraint

endclass: reg_cpu_data

`endif



