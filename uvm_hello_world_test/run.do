## ModleSim runscript for uvm_hello_world_test
## Use this as follows:
## > vsim -c -do run.do

vsim -c uvm_hello_world_tb +UVM_TESTNAME=uvm_hello_world_test
run -all
