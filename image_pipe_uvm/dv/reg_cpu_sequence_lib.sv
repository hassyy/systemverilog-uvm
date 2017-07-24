`ifndef __REG_CPU_SEQUENCE_LIB__
`define __REG_CPU_SEQUENCE_LIB__

`include "common_header.svh"
`include "reg_cpu_data.sv"


class reg_cpu_normal_sequence extneds uvm_sequence #(reg_cpu_data#());

    // Mandatory: Fatory registration
    `uvm_object_param_utils(reg_cpu_normal_sequence)


    // Mandatory: new
    function new(string name="reg_cpu_normal_sequence");
        super.new(name);
    endfunction: new


    // Mandatory: Main sequence
    virtual task body();

    endtask: body

endclass: reg_cpu_normal_sequence