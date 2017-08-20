`ifndef __RESET_TRANSACTION__
`define __RESET_TRANSACTION__

`include "common_header.svh"
`include "define.svh"


class reset_transaction extends uvm_sequence_item;

    rand bit reset_data;

    // Control Parameter
    rand bit first_flag;
    rand bit last_flag;

    // Timing Parameter
    // TODO: Separate into other files
    rand int wait_before_reset;
    rand int reset_cycle;


    // Default constraint
    constraint ct_default_data {
        soft reset_data==!`RESET_ACTIVE;
    }

    constraint ct_default_timing {
        soft wait_before_reset==1;
        soft reset_cycle==5;
    }

    `uvm_object_utils_begin(reset_transaction)
        `uvm_field_int(reset_data, UVM_DEFAULT)
        // Timing Parameter
        `uvm_field_int(wait_before_reset, UVM_DEFAULT)
        `uvm_field_int(reset_cycle, UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "reset_transaction");
        super.new(name);
    endfunction: new

    virtual function display();
        `uvm_info(
            get_name
            , $sformatf("RESET_TXN: reset_data=%x, wait_before_reset=%x, reset_cycle=%x"
                , reset_data, wait_before_reset, reset_cycle)
            , UVM_LOW
            )
    endfunction

endclass: reset_transaction

`endif
