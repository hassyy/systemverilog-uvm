`ifndef __IMAGE_PIPE_PRIMARY_TEST__
    `define __IMAGE_PIPE_PRIMARY_TEST__

`include "../dv/common_header.svh"
`include "../dv/image_pipe_sequence_lib.sv"
`include "../dv/image_pipe_data.sv"
`include "../dv/test_lib.sv"

class image_pipe_data_wait_before_transmit extends image_pipe_data;
  // Factory registration for overrideing.
  `uvm_object_utils(image_pipe_data_wait_before_transmit)

  // Override constraint of default_timing.
  constraint override_timing {
    // This will override the "soft" constriant
    wait_before_transmit==10;
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

    // Factory override
    image_pipe_data::type_id::set_type_override(image_pipe_data_wait_before_transmit::get_type());
  endfunction : build_phase

  virtual task run_phase(uvm_phase phase);
    many_random_sequence seq;

    super.run_phase(phase);
    phase.raise_objection(this);
    seq = many_random_sequence::type_id::create("seq");
    assert(seq.randomize());
    seq.start(env.penv_in.agent.sequencer);
    phase.drop_objection(this);
  endtask
endclass: image_pipe_primary_test

`endif
