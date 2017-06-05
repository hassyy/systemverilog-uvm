vlog -mfcu +incdir+../dv +define+QUESTA ../dv/pipe_pkg.svh ../interface/pipe_if.sv ../dv/tb.sv ../design/pipe.sv
#vopt +acc tb -o o_tb +designfile+tb.bin
vsim -c tb -classdebug -uvmcontrol=all +UVM_TESTNAME=random_test
