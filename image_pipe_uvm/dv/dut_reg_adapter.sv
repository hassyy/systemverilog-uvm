`ifndef __DUT_REG_ADAPTER__
`define __DUT_REG_ADAPTER__

`include "common_header.svh"
`include "reg_cpu_data.sv"

class dut_reg_adapter extends uvm_reg_adapter;

    // Mandatory: Factory registration
    `uvm_object_utils(dut_reg_adapter)

    // Mandatory: new
    function new (string name="");
        super.new(name);
        supports_byte_enable = 0;
        provides_responses = 1;
    endfunction: new

    // Access from reg_adapter to dut
    virtual function uvm_sequence_item reg2bus(const ref uvm_reg_bus_op rw);
        reg_cpu_data#() data_tx = reg_cpu_data#()::type_id::create("data_tx");

        if   (rw.kind==UVM_READ) begin
            data_tx.reg_cpu_cmd = reg_cpu_data#()::t_reg_cpu_cmd::READ;

            // data_tx.reg_cpu_cs = 1'b1;
            // data_tx.reg_cpu_we = 1'b1;
            data_tx.reg_cpu_wr_data = rw.data;
        end
        else
        if (rw.kind==UVM_WRITE)
            data_tx.reg_cpu_cmd = reg_cpu_data#()::t_reg_cpu_cmd::WRITE;
    endfunction: reg2bus

    virtual function void bus2reg(
        uvm_sequence_item bus_item, ref uvm_reg_bus_op rw);
        reg_cpu_data#() data_tx;

        // Check data_type for easy DEBUGING
        if (!$cast(data_tx, bus_item)) begin
            `uvm_fatal(get_name(), "bus_item is not of the reg_cpu_data type." )
            return;
        end

        rw.kind = (data_tx.reg_cpu_cmd==reg_cpu_data#()::t_reg_cpu_cmd::READ) ? UVM_READ : UVM_WRITE;
        if (data_tx.reg_cpu_cmd==reg_cpu_data#()::t_reg_cpu_cmd::READ)
            rw.data = data_tx.reg_cpu_rd_data;
        else
        if (data_tx.reg_cpu_cmd==reg_cpu_data#()::t_reg_cpu_cmd::WRITE)
            rw.data = data_tx.reg_cpu_wr_data;

        wr.status = UVM_IS_OK;
    endfunction: bus2reg

endclass: dut_reg_adapter

`endif