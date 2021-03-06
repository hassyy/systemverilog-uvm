# Create the library.
if [file exists work] {
    vdel -all
}
vlib work

set PATH_TO_ROOT_DIR ..
set DESIGN_PATH $PATH_TO_ROOT_DIR/design
set DV_PATH $PATH_TO_ROOT_DIR/dv
set TEST_PATH $PATH_TO_ROOT_DIR/test
set INTERFACE_PATH $PATH_TO_ROOT_DIR/interface

## For vlog, you must specify the .v files that are not included.
## e.g.) testbench, design, etc.

vlog ../dv/tb.sv \
     ../design/image_pipe.sv \
    -mfcu \
    -suppress 2269 -suppress 2286 -suppress 2643 \
    +define+QUESTA \
    +incdir+$DESIGN_PATH \
    +incdir+$DV_PATH \
    +incdir+$TEST_PATH \
    +incdir+$INTERFACE_PATH

vsim tb \
    -voptargs="+acc" -classdebug -uvmcontrol=all \
    +UVM_OBJECTION_TRACE \
    +UVM_TESTNAME=image_pipe_primary_test \

#add wave -position insertpoint sim:/tb/image_pipe_top/*
add wave -r /*

run -all

#quit -f
