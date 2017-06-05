`define __AHB_TRANSFER__

`include "common_header.svh"

`ifndef AHB_DATA_WIDTH
    `define AHB_DATA_WIDTH 32
`endif

`ifndef AHB_ADDR_WIDTH
    `define AHB_ADDR_WIDTH 32
`endif

typedef enum bit [2:0] {SINGLE, INCR, WRAP4, INCR4, WRAPS, INCR8, WRAP16, INCR16} hburst_t;
typedef enum bit [2:0] {HSIZE_8, HSIZE_16, HSIZE_32} hsize_t;
typedef enum bit [1:0] {IDLE, BUSY, NONSEQ, SEQ} htrans_t;
typedef enum bit       {OKAY, ERROR} hresp_t;
typedef enum bit       {READ, WRITE} hwrite_t;
typedef enum bit       {NOT_READY, READY} hready_t;

class ahb_transfer extends uvm_sequence_item;

    rand logic [`AHB_DATA_WIDTH-1:0] hwdata;
    rand logic [`AHB_DATA_WIDTH-1:0] hrdata;
    rand logic [`AHB_ADDR_WIDTH-1:0] haddr;
    rand hburst_t hburst;
    rand bit hmastlock;
    rand bit hprot;
    rand hsize_t hsize;
    rand hwrite_t hwrite;
    rand htrans_t htrans;
    rand hready_t hready;

    `uvm_object_utils_begin(ahb_transfer)
      `uvm_field_int(hwdata, UVM_DEFAULT)
      `uvm_field_int(hrdata, UVM_DEFAULT)
      `uvm_field_int(haddr, UVM_DEFAULT)
      `uvm_field_enum(hburst_t,hburst, UVM_DEFAULT)
      `uvm_field_int(hmastlock, UVM_DEFAULT)
      `uvm_field_int(hprot, UVM_DEFAULT)
      `uvm_field_enum(hsize_t, hsize, UVM_DEFAULT)
      `uvm_field_enum(hwrite_t, hwrite, UVM_DEFAULT)
      `uvm_field_enum(hready_t, hready, UVM_DEFAULT)
    `uvm_object_utils_end

    function new(string name = "ahb_transfer");
        super.new(name);
    endfunction: new

endclass