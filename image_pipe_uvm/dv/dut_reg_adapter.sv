`ifndef __DUT_REG_ADAPTER__
`define __DUT_REG_ADAPTER__

`include "common_header.svh"
`include "reg_cpu_data.sv"

class dut_reg_adapter extends uvm_reg_adapter;

    // Mandatory: Factory registration
    `uvm_object_utils(dut_reg_adapter)

    rand bit first_flag;

    // Mandatory: new
    function new (string name="");
        super.new(name);
        supports_byte_enable = 0;
        provides_responses = 1;    // This requires get_item_done(req) in driver.

        first_flag = 1;
    endfunction: new

    // You set the sequence_item (data_tx) here in reg2bus and bus2reg.
    // Then sequence_time will be passed to driver by calling write_reg() or read_reg()
    //   that calls reg2bus() or bus2reg()

    // Access from reg_adapter to DUT.
    virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
        reg_cpu_data#() data_tx = reg_cpu_data#()::type_id::create("data_tx");

        data_tx.reg_cpu_cmd = (rw.kind==UVM_READ) ? reg_cpu_data#()::READ : reg_cpu_data#()::WRITE;
        data_tx.reg_cpu_addr = rw.addr;
        data_tx.reg_cpu_data_wr = rw.data;

        if (first_flag) begin
            data_tx.first_flag = 1;
            first_flag = 0;
        end

        `uvm_info(get_name()
                    , $sformatf("[REG2BUS] cmd:%s, addr:%4h, data_wr:%4h"
                        , data_tx.reg_cpu_cmd
                        , data_tx.reg_cpu_addr
                        , data_tx.reg_cpu_data_wr)
                    , UVM_LOW)

        return data_tx;
    endfunction: reg2bus

    // DUT to reg_adapter
    virtual function void bus2reg(
        uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
        reg_cpu_data#() data_tx;

        `uvm_info(get_name(), "[BUS2REG]", UVM_LOW)

        // Check data_type for easy DEBUGING
        if (!$cast(data_tx, bus_item)) begin
            `uvm_fatal(get_name(), "bus_item is not of the reg_cpu_data type." )
            return;
        end

        if (first_flag) begin
            data_tx.first_flag = 1;
            first_flag = 0;
        end

        rw.kind = (data_tx.reg_cpu_cmd==reg_cpu_data#()::READ) ? UVM_READ : UVM_WRITE;

        rw.addr = data_tx.reg_cpu_addr;
        if (data_tx.reg_cpu_cmd==reg_cpu_data#()::READ)
            rw.data = data_tx.reg_cpu_data_rd;
        else
        if (data_tx.reg_cpu_cmd==reg_cpu_data#()::WRITE)
            rw.data = data_tx.reg_cpu_data_wr;

        rw.status = UVM_IS_OK;
    endfunction: bus2reg

endclass: dut_reg_adapter

`endif
