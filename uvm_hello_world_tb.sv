`include "uvm_macros.svh"
`include "uvm_hello_world_pkg.sv"
// `include "hello_world_test.sv"
import uvm_pkg::*;

module uvm_hello_world_tb();

	// Import package which include test, or you'll get the following error.
	// # UVM_WARNING @ 0: reporter [BDTYP] Cannot create a component of type 'base_test' because it is not registered with the factory
	// # UVM_FATAL @ 0: reporter [INVTST] Requested test from command line +UVM_TESTNAME=base_test not found.
	import uvm_hello_world_pkg::*;

	initial
		run_test();

endmodule