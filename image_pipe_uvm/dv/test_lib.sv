`ifndef __TEST_LIB__
    `define __TEST_LIB__

`include "common_header.svh"
`include "dut_env.sv"
`include "image_pipe_sequence_lib.sv"
`include "dut_reg_block.sv"


class base_test extends uvm_test;
    `uvm_component_utils(base_test)

    dut_env env;
    uvm_table_printer printer;
    dut_reg_block reg_block;

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        // Instantiate reg_block and set address map. 
        reg_block = dut_reg_block::type_id::create("reg_block"); 
        reg_block.build();

        // Set the mapped reg_block to env.reg_block
        env = dut_env::type_id::create("env", this);
        env.reg_block = reg_block;

        printer = new( );
        printer.knobs.depth = 5;
    endfunction: build_phase

    virtual function void end_of_elaboration_phase(uvm_phase phase);
        `uvm_info(get_type_name( ), $sformatf("Printing the test topology :\n%s", this.sprint(printer)), UVM_LOW)
    endfunction: end_of_elaboration_phase

    virtual task run_phase(uvm_phase phase);
        phase.phase_done.set_drain_time(this, 1500);
    endtask: run_phase

endclass : base_test

`endif
