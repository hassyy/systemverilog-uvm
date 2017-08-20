`ifndef __IMAGE_PIPE__
`define __IMAGE_PIPE__

`include "../interface/image_pipe_if.sv"
`include "../interface/reg_cpu_if.sv"
`include "../dv/define.svh"

module image_pipe
    #(parameter DW_IN=`IMAGE_PIPE_DW_IN1, DW_OUT=`IMAGE_PIPE_DW_OUT1)
    (
    input wire clk
    , input wire s_rst_n
    , input wire reg_cpu_rst_n
    // IMAGE_PIPE
    , input wire [DW_IN-1:0] image_pipe_data_in
    , input wire image_pipe_valid_in
    , input wire image_pipe_end_in
    , output reg image_pipe_busy_out
    , output reg [DW_OUT-1:0] image_pipe_data_out
    , output reg image_pipe_valid_out
    , output reg image_pipe_end_out
    , input wire image_pipe_busy_in
    // REG_CPU
    , input wire reg_cpu_cs
    , input wire [31:2] reg_cpu_addr
    , input wire [31:0] reg_cpu_data_wr
    , output reg [31:0] reg_cpu_data_rd
    , input wire reg_cpu_we
    , output reg reg_cpu_wack
    , input wire reg_cpu_re
    , output reg reg_cpu_rdv

    );

////////// IMAGE_PIPE

logic [DW_IN-1:0] data_tmp;
logic valid_tmp;

always @(posedge clk) begin
    if (!s_rst_n)
        image_pipe_busy_out <= 1'b0;
    else begin
        if (image_pipe_busy_in)
            image_pipe_busy_out <= 1'b1;
        else
        if (valid_tmp)
            image_pipe_busy_out <= 1'b1;
        else
            image_pipe_busy_out <= 1'b0;
    end
end

always @(posedge clk) begin
    if (!s_rst_n) begin
        image_pipe_data_out  <= '0;
        image_pipe_valid_out <= '0;
    end
    else begin
        if (!image_pipe_busy_in) begin
            image_pipe_data_out <= data_tmp;
            image_pipe_valid_out <= valid_tmp;
        end
    end
end

always @(posedge clk) begin
    if (!s_rst_n)
        image_pipe_end_out <= 1'b0;
    else begin
        if (image_pipe_end_out) begin
            if (!image_pipe_busy_in)
                image_pipe_end_out <= 1'b0;
        end
        else
        if (image_pipe_end_in)
            image_pipe_end_out <= 1'b1;
    end
end

always @(posedge clk) begin
    if (!s_rst_n) begin
        data_tmp <= '0;
        valid_tmp <= 1'b0;
    end
    else begin
        if (valid_tmp) begin
            if (!image_pipe_busy_in)
                valid_tmp <= 1'b0;
        end
        else
        if (image_pipe_valid_in & !image_pipe_busy_in) begin
            data_tmp <= image_pipe_data_in;
            valid_tmp <= image_pipe_valid_in;
        end
        else
            valid_tmp <= 1'b0;
    end
end



////////// REG_CPU

    reg [12: 0] i_reg_1;
    reg [15: 0] i_reg_2;

    localparam ADDR_REG_1  = 14'h0;     // 0x82060000;
    localparam ADDR_REG_2   = 14'h1;     // 0x82060004;

    localparam DEFAULT_REG_1            = 13'h0;
    localparam DEFAULT_REG_2              = 16'h0;

    // Use RE Rising Edge For reg_cpu_data_rd latch
    reg  reg_cpu_re_ff1;
    wire reg_cpu_re_rise_edge;


//-------------------------------------------------------------------
//  reg_mainpix : [READ_WRITE]

    always @ (posedge clk) begin
        if (!reg_cpu_rst_n) begin
            i_reg_1 <= DEFAULT_REG_1;
        end
        else
        if (reg_cpu_cs && reg_cpu_we &&
            reg_cpu_addr == ADDR_REG_1) begin
            i_reg_1 <= reg_cpu_data_wr[12: 0];
        end
    end

//-------------------------------------------------------------------
//  reg_subpix : [READ_WRITE]

    always @ (posedge clk) begin
        if (!reg_cpu_rst_n) begin
            i_reg_2 <= DEFAULT_REG_2;
        end
        else
        if (reg_cpu_cs && reg_cpu_we &&
            reg_cpu_addr == ADDR_REG_2) begin
            i_reg_2 <= reg_cpu_data_wr[15: 0];
        end
    end

//-------------------------------------------------------------------
//  WACK

    always @ (posedge clk) begin
        if (!reg_cpu_rst_n)
            reg_cpu_wack <= 1'b0;
        else if (reg_cpu_cs && reg_cpu_we)
            reg_cpu_wack <= 1'b1;
        else
            reg_cpu_wack <= 1'b0;
    end

//-------------------------------------------------------------------
//  RDACK

    always @ (posedge clk) begin
        if (!reg_cpu_rst_n)
            reg_cpu_rdv <= 1'b0;
        else
        // for NON-SRAM READ
        if (reg_cpu_cs && reg_cpu_re)
            reg_cpu_rdv <= 1'b1;
        else
            reg_cpu_rdv <= 1'b0;
    end

//-------------------------------------------------------------------
//  reg_cpu_re_rise_edge to latch reg_cpu_data_rd at the begining of read request

    always @ (posedge clk) begin
        if (!reg_cpu_rst_n)
            reg_cpu_re_ff1 <= 1'b0;
        else
            reg_cpu_re_ff1 <= reg_cpu_re;
    end

    assign reg_cpu_re_rise_edge = reg_cpu_re & !reg_cpu_re_ff1;

//-------------------------------------------------------------------
//  DATA READ

    always @ (posedge clk) begin
        if (!reg_cpu_rst_n)
            reg_cpu_data_rd <= 32'h00000000;
        else
        //  Latch reg_cpu_data_rd to avoid unexpected UBus Monitor Error
        if (reg_cpu_cs & reg_cpu_re_rise_edge) begin
            case (reg_cpu_addr[15:2])
                ADDR_REG_1 :
                    reg_cpu_data_rd <= 32'h00000000 | (i_reg_1 <<  0);
                ADDR_REG_2 :
                    reg_cpu_data_rd <= 32'h00000000 | (i_reg_2 <<  0);
                default : reg_cpu_data_rd <= 32'h00000000;
            endcase
        end
    end

endmodule

`endif
