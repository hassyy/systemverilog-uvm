`ifndef __REG_CPU_SEQUENCE_LIB__
`define __REG_CPU_SEQUENCE_LIB__

`include "common_header.svh"
`include "dut_reg_block.sv"


class reg_cpu_normal_sequence extends uvm_reg_sequence#();

    // Mandatory: Fatory registration
    `uvm_object_param_utils(reg_cpu_normal_sequence)


    // Mandatory: new
    function new(string name="reg_cpu_normal_sequence");
        super.new(name);
    endfunction: new


    // Mandatory: Main sequence
    virtual task body();

        // Declare reg_block
        dut_reg_block reg_block;

        // Built-in fields
        uvm_status_e status;
        uvm_reg_data_t value;


        // Prepare built-in "model" as "reg_block".
        // FYI) "model" is declared in uvm_reg_sequence and
        //      used for the register block abstraction.
        $cast(reg_block, model);


        //------ Register senario
        // Do write, Read by calling RAL API.
        write_reg(reg_block.reg_1, status, 32'hFFFF);
        read_reg(reg_block.reg_1, status, value);

        write_reg(reg_block.reg_2, status, 32'hFFFF);
        read_reg(reg_block.reg_2, status, value);

    endtask: body

endclass: reg_cpu_normal_sequence

`endif
