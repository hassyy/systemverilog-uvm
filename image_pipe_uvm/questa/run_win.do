vlog -mfcu +incdir+../dv +define+QUESTA ../dv/pipe_pkg.svh ../interface/pipe_if.sv ../dv/tb.sv ../design/pipe.sv
vsim -c tb -classdebug -uvmcontrol=all +UVM_TESTNAME=random_test
