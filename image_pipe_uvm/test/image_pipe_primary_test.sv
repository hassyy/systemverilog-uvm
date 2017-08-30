`ifndef __IMAGE_PIPE_PRIMARY_TEST__
`define __IMAGE_PIPE_PRIMARY_TEST__

`include "test_common.svh"


class image_pipe_data_random_timing#(int DW_IN=`TEST_IMAGE_PIPE_DW_IN, int DW_OUT=`TEST_IMAGE_PIPE_DW_OUT)
    extends image_pipe_data#(DW_IN, DW_OUT);

    // Factory registration for overrideing.
    `uvm_object_param_utils(image_pipe_data_random_timing#(DW_IN, DW_OUT))

    // Override soft constraint of default_timing.
    constraint override_timing {
        // Override the "soft" constriant
        wait_before_transmit inside {[5:10]};
        valid_interval       inside {[0:2]};
        wait_before_end      inside {[0:5]};

        busy_assert_cycle inside {[1:3]};
        busy_negate_cycle inside {[1:5]};
    }

    function new(string name="image_pipe_data_random_timing");
        super.new(name);
    endfunction: new

    // Override displayAll()
    virtual task displayAll();
    `uvm_info("DP", $sformatf("wait_before_transmit=%0d"
        , wait_before_transmit)
        , UVM_LOW)
    endtask: displayAll

endclass

class image_pipe_primary_test extends base_test;
    `uvm_component_utils(image_pipe_primary_test)

    localparam DW_IN=`TEST_IMAGE_PIPE_DW_IN;
    localparam DW_OUT=`TEST_IMAGE_PIPE_DW_OUT;
    localparam AW=`TEST_REG_CPU_AW;
    localparam DW=`TEST_REG_CPU_DW;


    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction : new

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        // Factory override for the image_pipe timing parameter
        image_pipe_data#(DW_IN, DW_OUT)::type_id::set_type_override(image_pipe_data_random_timing#(DW_IN, DW_OUT)::get_type());
    endfunction : build_phase

    virtual task run_phase(uvm_phase phase);

        // Declare the sequence to use in your test.
        image_pipe_reg_cpreg_cpu_simple_vsequence#(DW_IN, DW_OUT, AW, DW) v_seq;

        super.run_phase(phase);

        // Set flag for timeout.
        phase.raise_objection(this);

        // Instantiate virtual sequencer.
        v_seq = image_pipe_reg_cpreg_cpu_simple_vsequence#(DW_IN, DW_OUT, AW, DW)::type_id::create("v_seq");

        // Instantiate v_seq.reg_cpu_seq here to assign reg_block.
        v_seq.reg_cpu_seq = reg_cpu_normal_sequence#(AW,DW)::type_id::create("reg_cpu_seq");
        v_seq.reg_cpu_seq.model = reg_block;  // for RAL

        // Start senario:
        v_seq.start(env.v_seqr);
        //v_seq.start(null);

        // Reset flag for timeout.
        phase.drop_objection(this);

    endtask
endclass: image_pipe_primary_test

`endif
