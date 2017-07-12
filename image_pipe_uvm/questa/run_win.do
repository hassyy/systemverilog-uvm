# Create the library.
if [file exists work] {
    vdel -all
}
vlib work

set DESIGN_PATH "../design"
set DV_PATH "../dv"
set TEST_PATH "../test"

vlog -suppress 2269 -suppress 2286 -suppress 2643 -mfcu +incdir+../dv +incdir+../test +define+QUESTA ../dv/image_pipe_pkg.svh ../interface/image_pipe_if.sv ../dv/tb.sv $DESIGN_PATH/image_pipe.sv

vsim tb -voptargs="+acc" -classdebug -uvmcontrol=all \
+UVM_OBJECTION_TRACE \
+UVM_TESTNAME=image_pipe_primary_test \

#add wave -position insertpoint sim:/tb/image_pipe_top/*
add wave -r /*

run -all

#quit -f
