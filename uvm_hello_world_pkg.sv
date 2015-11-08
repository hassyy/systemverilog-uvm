package uvm_hello_world_pkg;
	import uvm_pkg::*;

	// Include test in the package, or you might see the following Warning/Error.
	// # UVM_WARNING @ 0: reporter [BDTYP] Cannot create a component of type 'base_test' because it is not registered with the factory
	// # UVM_FATAL @ 0: reporter [INVTST] Requested test from command line +UVM_TESTNAME=base_test not found.

	`include "uvm_hello_world_test.sv"
endpackage : uvm_hello_world_pkg