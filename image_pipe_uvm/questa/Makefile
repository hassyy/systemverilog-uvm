ROOT_DIR = ..

DESIGN_ROOT_DIR = $(ROOT_DIR)/design
INTERFACE_ROOT_DIR = $(ROOT_DIR)/interface
DV_ROOT_DIR = $(ROOT_DIR)/dv
TEST_ROOT_DIR = $(ROOT_DIR)/test
TESTBENCH_ROOT_DIR = $(ROOT_DIR)/testbench


##### DUT

TARGET_DUT_DIR   = $(DESIGN_ROOT_DIR)
TARGET_DUT_FILES = $(TARGET_DUT_DIR)/image_pipe.sv

##### INTERFACE

TARGET_INTERFACE_DIR   = $(INTERFACE_ROOT_DIR)
TARGET_INTERFACE_FILES = $(TARGET_INTERFACE_DIR)/image_pipe_if.sv \
                         $(TARGET_INTERFACE_DIR)/reg_cpu_if.sv \
                         $(TARGET_INTERFACE_DIR)/reset_if.sv

##### DV

TARGET_IMAGE_PIPE_PKG_DIR   = $(DV_ROOT_DIR)/image_pipe
TARGET_IMAGE_PIPE_PKG_FILES = $(TARGET_IMAGE_PIPE_PKG_DIR)/image_pipe_pkg.svh \

TARGET_REG_CPU_PKG_DIR   = $(DV_ROOT_DIR)/reg_cpu
TARGET_REG_CPU_PKG_FILES = $(TARGET_REG_CPU_PKG_DIR)/reg_cpu_pkg.svh \

TARGET_RESET_PKG_DIR   = $(DV_ROOT_DIR)/reset
TARGET_RESET_PKG_FILES = $(TARGET_RESET_PKG_DIR)/reset_pkg.svh \

TARGET_DUT_REG_PKG_DIR   = $(DV_ROOT_DIR)/dut_reg
TARGET_DUT_REG_PKG_FILES = $(TARGET_DUT_REG_PKG_DIR)/dut_reg_pkg.svh \

TARGET_SEQUENCE_PKG_DIR   = $(DV_ROOT_DIR)/sequence
TARGET_SEQUENCE_PKG_FILES = $(TARGET_SEQUENCE_PKG_DIR)/sequence_pkg.svh \

TARGET_DUT_ENV_PKG_DIR   = $(DV_ROOT_DIR)/dut_env
TARGET_DUT_ENV_PKG_FILES = $(TARGET_DUT_ENV_PKG_DIR)/dut_env_pkg.svh \


##### TEST

TARGET_TEST_PKG_DIR   = $(TEST_ROOT_DIR)
TARGET_TEST_PKG_FILES = $(TARGET_TEST_PKG_DIR)/test_pkg.svh \


##### TB

TARGET_TB_DIR   = $(TESTBENCH_ROOT_DIR)
TARGET_TB_FILES = $(TARGET_TB_DIR)/tb.sv \


##### VLOG

VLOG_SUPPRESS_OPT = -suppress 2643 -suppress 2269
VLOG_OPT = -incr -sv $(VLOG_SUPPRESS_OPT)

##### VSIM

VSIM_OPT = -c -classdebug -uvmcontrol=all -voptargs="+acc"
TESTBENCH_NAME = tb
D_TESTNAME = +UVM_TESTNAME=image_pipe_primary_test
DOFILE = "add wave -position insertpoint sim:/tb/image_pipe_top/* ; run -all; q"
DUMPLOG = sim.log

##### TARGETs

run_sim:
	vsim \
		$(TESTBENCH_NAME) \
		$(VSIM_OPT) \
		-do $(DOFILE) \
		-l  sim.log \
		$(D_TESTNAME)


compile_tb:
	vlog \
		$(VLOG_OPT) \
		+incdir+$(TARGET_TB_DIR) \
		$(TARGET_TB_FILES)

compile_dut:
	vlog \
		$(VLOG_OPT) \
		+incdir+$(TARGET_DUT_DIR) \
		$(TARGET_DUT_FILES)

compile_interface:
	vlog \
		$(VLOG_OPT) \
		+incdir+$(TARGET_INTERFACE_DIR) \
		$(TARGET_INTERFACE_FILES)

compile_image_pipe_pkg:
	vlog \
		$(VLOG_OPT) \
		+incdir+$(TARGET_IMAGE_PIPE_PKG_DIR) \
		$(TARGET_IMAGE_PIPE_PKG_FILES)

compile_reg_cpu_pkg:
	vlog \
		$(VLOG_OPT) \
		+incdir+$(TARGET_REG_CPU_PKG_DIR) \
		$(TARGET_REG_CPU_PKG_FILES)

compile_reset_pkg:
	vlog \
		$(VLOG_OPT) \
		+incdir+$(TARGET_RESET_PKG_DIR) \
		$(TARGET_RESET_PKG_FILES)

compile_dut_reg_pkg:
	vlog \
		$(VLOG_OPT) \
		+incdir+$(TARGET_DUT_REG_PKG_DIR) \
		$(TARGET_DUT_REG_PKG_FILES)

compile_sequence_pkg:
	vlog \
		$(VLOG_OPT) \
		+incdir+$(TARGET_SEQUENCE_PKG_DIR) \
		$(TARGET_SEQUENCE_PKG_FILES)

compile_dut_env_pkg:
	vlog \
		$(VLOG_OPT) \
		+incdir+$(TARGET_DUT_ENV_PKG_DIR) \
		$(TARGET_DUT_ENV_PKG_FILES)

compile_test_pkg:
	vlog \
		$(VLOG_OPT) \
		+incdir+$(TARGET_TEST_PKG_DIR) \
		$(TARGET_TEST_PKG_FILES)


compile_all: compile_dut compile_dv compile_tb
compile_dut: compile_interface compile_dut
compile_dv: compile_image_pipe_pkg \
			compile_reg_cpu_pkg \
			compile_reset_pkg \
			compile_sequence_pkg \
			compile_dut_reg/_pkg \
			compile_dut_env_pkg \
			compile_test_pkg
clean:
	vdel -all
