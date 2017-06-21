# Create the library.
if [file exists work] {
    vdel -all
}
vlib work

vlog -suppress 2269 -suppress 2286 -suppress 2643 -mfcu +incdir+../dv +define+QUESTA ../dv/image_pipe_pkg.svh ../interface/image_pipe_if.sv ../dv/tb.sv ../design/image_pipe.sv

vsim tb -voptargs="+acc" -classdebug -uvmcontrol=all +UVM_TESTNAME=many_random_test

add wave -position insertpoint sim:/tb/image_pipe_top/*

run -all

#quit -f
