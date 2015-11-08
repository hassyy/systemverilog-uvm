`include "uvm_macros.svh"
import uvm_pkg::*;

class uvm_hello_world_test extends uvm_test;
	`uvm_component_utils(uvm_hello_world_test)

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		`uvm_info("TEST", "UVM_HELLO_WORLD !!!", UVM_MEDIUM);
		phase.drop_objection(this);
	endtask
endclass