`ifndef __PIPE__
    `define __PIPE__

module pipe(
    clk
    , rst_n
    , i_cf
    , i_en
    , i_data0
    , i_data1
    , o_data0
    , o_data1
    );

input wire clk;
input wire rst_n;
input wire [1:0] i_cf;
input wire i_en;
input wire [15:0] i_data0;
input wire [15:0] i_data1;

output reg [15:0] o_data0;
output reg [15:0] o_data1;

reg [15:0] data_0;
reg [15:0] data_1;

always @(posedge clk) begin
    if (!rst_n) begin
        data_0 <= '0;
        data_1 <= '0;
    end
    else begin
        if (i_en) begin
            if ((i_data0==16'h0000) || (i_data0==16'hFFFF)) begin
                data_0 <= i_data0;
            end
            else begin
                data_0 <= i_data0 * i_cf;
            end

            if ((i_data1==16'h0000) || (i_data1==16'hFFFF)) begin
                data_1 <= i_data1;
            end
            else begin
                data_1 <= i_data1 * i_cf;
            end
        end
    end
end

always @(posedge clk) begin
    o_data0 <= data_0;
    o_data1 <= data_1;
end

endmodule

`endif
