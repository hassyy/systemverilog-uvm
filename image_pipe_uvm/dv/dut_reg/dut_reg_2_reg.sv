`ifndef __DUT_REG_2_REG__
`define __DUT_REG_2_REG__

`include "dut_reg_common.svh"

class dut_reg_2_reg extends uvm_reg;

    `uvm_object_utils(dut_reg_2_reg)

    rand uvm_reg_field reg_2_field_1;

    function new(string name="dut_reg_2_reg");
        super.new(  .name(name)
                    , .n_bits(15)
                    , .has_coverage(UVM_NO_COVERAGE)
                    );
    endfunction: new

    virtual function void build();
        // Instanciate fields by Factory, then confiture
        reg_2_field_1 = uvm_reg_field::type_id::create("reg_2_field_1");
        reg_2_field_1.configure(.parent(this)
                                , .size(15)
                                , .lsb_pos(0)
                                , .access("RW")
                                , .volatile(0)
                                , .reset(0)
                                , .has_reset(1)
                                , .is_rand(1)
                                , .individually_accessible(0)
                                );
    endfunction: build

    // For backdoor
    add_hdl_path_slice( .name( "reg_2_field_1" )
                        , .offset( 0 )    // start bit as lsb_pos
                        , .size( 15 )      // bit size as size
                        );

endclass: dut_reg_2_reg

`endif
