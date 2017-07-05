`ifndef __IMAGE_PIPE_PRIMARY_TEST__
    `define __IMAGE_PIPE_PRIMARY_TEST__

`include "../dv/common_header.svh"
`include "../dv/define.svh"
`include "../dv/image_pipe_sequence_lib.sv"
`include "../dv/image_pipe_data.sv"
`include "../dv/test_lib.sv"

class image_pipe_data_random_timing extends image_pipe_data#(`IMAGE_PIPE_DW_IN1,`IMAGE_PIPE_DW_OUT1);

  // Factory registration for overrideing.
  `uvm_object_utils(image_pipe_data_random_timing)

  // Override soft constraint of default_timing.
  constraint override_timing {
    // Override the "soft" constriant
    wait_before_transmit inside {[5:10]};
    valid_interval       inside {[0:2]};
    wait_before_end      inside {[0:5]};
  }

  // Override displayAll()
  virtual task displayAll();
    `uvm_info("DP", $sformatf("wait_before_transmit=%0d"
      , wait_before_transmit)
      , UVM_LOW)
  endtask: displayAll

endclass

class image_pipe_primary_test extends base_test;
  `uvm_component_utils(image_pipe_primary_test)

  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    // Factory override for the image_pipe timing parameter
    image_pipe_data#()::type_id::set_type_override(image_pipe_data_random_timing::get_type());
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    many_random_sequence#(32,32) seq;

    super.run_phase(phase);
    phase.raise_objection(this);
    seq = many_random_sequence#(32,32)::type_id::create("seq");
    assert(seq.randomize());
    seq.start(env.penv_in.agent.sequencer);
    phase.drop_objection(this);
  endtask
endclass: image_pipe_primary_test

`endif
