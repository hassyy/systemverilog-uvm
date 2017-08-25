`include "image_pipe_common.svh"


class image_pipe_coverage#(int DW_IN, int DW_OUT)
    extends uvm_subscriber #(image_pipe_data#(DW_IN, DW_OUT));

    image_pipe_data#(DW_IN, DW_OUT) ip_data;
    int count;

    `uvm_component_param_utils(image_pipe_coverage#(DW_IN, DW_OUT))

    covergroup cg;
        option.per_instance = 1;
        cov_image_pipe_data_in  : coverpoint ip_data.image_pipe_data_in;
        cov_image_pipe_valid_in : coverpoint ip_data.image_pipe_valid_in;
        cov_image_pipe_end_in   : coverpoint ip_data.image_pipe_end_in;
        cov_image_pipe_busy_out : coverpoint ip_data.image_pipe_busy_out;
        cov_ipm_data_out : coverpoint ip_data.ipm_data_out;
        cov_ipm_valid_out: coverpoint ip_data.ipm_valid_out;
        cov_ipm_end_out  : coverpoint ip_data.ipm_end_out;
        cov_ipm_busy_in  : coverpoint ip_data.ipm_busy_in;
    endgroup: cg

    function new(string name, uvm_component parent);
        super.new(name, parent);
        cg = new( );
    endfunction: new

    function void write(image_pipe_data#(DW_IN, DW_OUT) t);
        ip_data = t;
        count++;
        cg.sample( );
    endfunction: write

    virtual function void extract_phase(uvm_phase phase);
        `uvm_info(get_type_name( ), $sformatf("Number of data collected = %0d", count), UVM_LOW)
        `uvm_info(get_type_name( ), $sformatf("Current coverage = %f", cg.get_coverage( )), UVM_LOW)
    endfunction: extract_phase

endclass : image_pipe_coverage
