`ifndef __DUT_REG_TEST__
`define __DUT_REG_TEST__

`include "test_common.svh"


class dut_reg_test extends base_test;
    `uvm_component_utils(dut_reg_test)

    localparam DW_IN=`TEST_IMAGE_PIPE_DW_IN;
    localparam DW_OUT=`TEST_IMAGE_PIPE_DW_OUT;
    localparam AW=`TEST_REG_CPU_AW;
    localparam DW=`TEST_REG_CPU_DW;


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new


    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction : build_phase


    virtual task run_phase(uvm_phase phase);

        // Declare the sequence to use in your test.
        uvm_reg_hw_reset_seq reg_hw_reset_seq;
        uvm_reg_access_seq reg_access_seq;
        reset_sequence reset_seq;

        super.run_phase(phase);

        phase.raise_objection(this, "DUT_REG_TEST_STARTED");  // Disable TIMEOUT

        // Instantiate reg sequence.
        // Set reg_block to the model of reg sequence
        reg_hw_reset_seq = uvm_reg_hw_reset_seq::type_id::create("reg_hw_reset_seq");
        reg_hw_reset_seq.model = reg_block;

        reg_access_seq = uvm_reg_access_seq::type_id::create("reg_access_seq");
        reg_access_seq.model = reg_block;

        reset_seq = reset_sequence::type_id::create("reset_seq");

        // Start senario
        reset_seq.start(env.rst_agent.sequencer);
        reg_hw_reset_seq.start(null);
        reg_access_seq.start(null);

        phase.drop_objection(this, "DUT_REG_TEST_DONE");  // Enbale TIMEOUT

    endtask

endclass: dut_reg_test

`endif
