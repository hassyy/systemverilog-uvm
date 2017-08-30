`ifndef __REG_CPU_SEQUENCE_LIB__
`define __REG_CPU_SEQUENCE_LIB__

`include "sequence_common.svh"

// uvm_reg_sequence doesnot need the template parameter.
class reg_cpu_sequence_base#(int AW, int DW) extends uvm_reg_sequence;

    // Mandatory: Fatory registration
    `uvm_object_param_utils(reg_cpu_sequence_base#(AW, DW))

    dut_reg_block reg_block;
    uvm_status_e status;
    uvm_reg_data_t value;

    // Mandatory: new
    function new(string name="reg_cpu_sequence_base");
        super.new(name);
    endfunction: new

    // Objection control. This is a common housekeeping code
    virtual task pre_body();
        if (starting_phase!=null)
            starting_phase.raise_objection(this, "SEQ_STARTED");
    endtask: pre_body

    // Mandatory: Main sequence
    virtual task body();
        $cast(reg_block, model);  // needed for the register block abstraction.

    endtask: body

    virtual task post_body();
        if (starting_phase!=null)
            starting_phase.drop_objection(this, "SEQ_DONE");
    endtask: post_body

endclass: reg_cpu_sequence_base


class reg_cpu_normal_sequence#(int AW, int DW) extends reg_cpu_sequence_base#(AW, DW);
    // Mandatory: Fatory registration
    `uvm_object_param_utils(reg_cpu_normal_sequence#(AW, DW))

    // Mandatory: new
    function new(string name="reg_cpu_normal_sequence");
        super.new(name);
    endfunction: new

    virtual task body();
        super.body();  // $cast(reg_block, model)t

        //------ Register senario
        // Do write, Read by calling RAL API.
        write_reg(reg_block.reg_1, status, 32'hFFFF);
        read_reg(reg_block.reg_1, status, value);

        write_reg(reg_block.reg_2, status, 32'hFFFF);
        read_reg(reg_block.reg_2, status, value);
    endtask: body

endclass: reg_cpu_normal_sequence

`endif
