`include "uvm_macros.svh"
`include "uvm_hello_world_pkg.sv"
 // `include "uvm_hello_world_test.sv"
import uvm_pkg::*;
import uvm_hello_world_pkg::*;

module uvm_hello_world_tb();

	initial
		run_test();

endmodule