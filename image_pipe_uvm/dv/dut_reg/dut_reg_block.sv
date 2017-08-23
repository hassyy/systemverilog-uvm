`ifndef __DUT_REG_BLOCK__
`define __DUT_REG_BLOCK__

`include "dut_reg_1_reg.sv"
`include "dut_reg_2_reg.sv"

class dut_reg_block extends uvm_reg_block;

    // Madatory: Factory registration
    `uvm_object_utils(dut_reg_block)

    // Declare registers to map
    rand dut_reg_1_reg reg_1;
    rand dut_reg_2_reg reg_2;
    // This is the reg_map
    uvm_reg_map reg_map;


    function new(string name="dut_reg_block");
        super.new(.name(name), .has_coverage(UVM_NO_COVERAGE));
    endfunction: new


    virtual function void build();
        // Instanciate registers by factory
        reg_1 = dut_reg_1_reg::type_id::create("dut_reg_1");
        reg_1.configure(.blk_parent(this));
        reg_1.build();

        reg_2 = dut_reg_2_reg::type_id::create("dut_reg_2");
        reg_2.configure(.blk_parent(this));
        reg_2.build();

        // Create reg_map
        reg_map = create_map(.name("reg_map"), .base_addr(8'h00), .n_bytes(4), .endian(UVM_LITTLE_ENDIAN));
        // Add registers to reg_map
        reg_map.add_reg(.rg(reg_1), .offset(8'h00), .rights("RW"));
        reg_map.add_reg(.rg(reg_2), .offset(8'h04), .rights("RW"));

        // BACKDOOR ACCESS
        add_hdl_path(.path("tb.image_pipe_top"));

        // Fix address map
        lock_model();

    endfunction: build

endclass: dut_reg_block

`endif
