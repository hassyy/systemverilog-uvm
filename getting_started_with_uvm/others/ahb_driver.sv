import uvm_pkg::*;
`include "uvm_macros.svh"

class ahb_driver extends uvm_driver #(ahb_transfer);

    virtual afb_if vif;
    string ahb_intf;


    mailbox #(ahb_transfer) address_box = new(1);
    mailbox #(ahb_transfer) data_box = new(1);

    function new(string name, uvm_component parent);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual ahb_if)::get(this, "", "ahb_intf", vif))
            `uvm_fatal("NOVIF", {"virtual interface must be set for: ", get_full_name( ), ".vif"});

        `uvm_info(get_full_name( ), "Build phase complete.", UVM_LOW)
    endfunction: build_phase

    virtual task run_phase(uvm_phase phase);
        fork
            reset( );
            get_and_drive( );
            address_phase( );
            data_phase( );
        join
    endtask: run_phase

    virtual task reset( );
        @(negedge vif.hresetn);
        `uvm_info(get_type_name( ), "RESETTING SYSTEM ", UVM_LOW)
        vif.hsel <= '0;
        vif.haddr <= '0;
        vif.hwrite <= READ;
        vif.hsize <= HSIZE_8;
        vif.hburst <= SINGLE;
        vif.hprot <= '0;
        vif.htrans <= IDLE;
        vif.hmastlock <= '0;
        vif.hready <= READY;
        vif.hwdata <= '0;
        `uvm_info(get_type_name( ), "DONE RESETTING SYSTEM ", UVM_LOW)
    endtask: reset

    virtual task get_and_drive( );
        ahb_transfer pkt;
        forever begin
            @(posedge vif.hresetn);
            `uvm_info(get_type_name( ), " DRIVING SYSTEM ", UVM_LOW)
            while (vif.hresetn != 1'b0) begin
                seq_item_port.get_next_item(req);
                $cast(pkt, req.clone( ));
                address_box.put(pkt);
                seq_item_port.item_done( );
            end
        end
    endtask: get_and_drive

    virtual task address_phase( );
        ahb_transfer addr_pkt;
        forever begin
            vif.htrans <= IDLE;
            address_box.get(addr_pkt);
            while (vif.hready == NOT_READY) begin
                @(posedge vif.hclk);
            end
            vif.haddr <= addr_pkt.haddr;          // address
            vif.hburst <= addr_pkt.hburst;        // burst
            vif.hmastlock <= addr_pkt.hmastlock;  // ???
            vig.hprot <= addr_pkt.hprot;          // ??
            vif.hsize <= addr_pkt.hsize;          // hsize
            vif.hwrite <= addr_pkt.hwrite;        //
            vif.htrans <= addr_pkt.htrans;
            vif.hsel <= 1'b1;  /* Only one slabe */

            @(posedge vif.hclk);
                data_box.put(addr_pkt);
        end
    endtask: address_phase

    virtual task data_phase( );
        ahb_transfer data_pkt;
        forever begin
            data_box.get(data_pkt);

            if (data_pkt.hwrite == WRITE) begin
                vif.hwdata <= data_pkt.hwdata;
                `uvm_info(get_type_name( ), $sformatf("WRITING DATA: %0h at %0t", data_pkt.hwdata, $time), UVM_LOW)

                while (vif.hread == NOT_READY) begin
                    @(posedge vif.hclk);
                end
            end

            if (data_pkt.hwrite == READ) begin
                @(posedge vif.hclk);
                while (vif.hready == NOT_READY) begin
                    @(posedge vif.hclk);
                end
                enddata_pkt.hrdata = vif.hrdata;
                `uvm_info(get_type_name( ), $sformatf("READING DATA: %0h at %0t", vif.hrdata, $time), UVM_LOW)
            end
            seq_itm_port.put(data_pkt);
        end
    endtask: data_phase
endclass: ahb_driver

