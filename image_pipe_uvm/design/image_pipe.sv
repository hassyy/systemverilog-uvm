`ifndef __IMAGE_PIPE__
    `define __IMAGE_PIPE__

module image_pipe
    #(parameter DW_IN=32, DW_OUT=32)
    (
    input wire clk
    , input wire rst_n
    , input wire [DW_IN-1:0] is_data_in
    , input wire is_valid_in
    , input wire is_end_in
    , output reg is_busy_out
    , output reg [DW_OUT-1:0] im_data_out
    , output reg im_valid_out
    , output reg im_end_out
    , input wire im_busy_in
    );

logic [DW_IN-1:0] data_tmp;
logic valid_tmp;

always @(posedge clk) begin
    if (!rst_n)
        is_busy_out <= 1'b0;
    else begin
        if (im_busy_in)
            is_busy_out <= 1'b1;
        else
        if (valid_tmp)
            is_busy_out <= 1'b1;
        else
            is_busy_out <= 1'b0;
    end
end

always @(posedge clk) begin
    if (!rst_n) begin
        im_data_out  <= '0;
        im_valid_out <= '0;
    end
    else begin
        if (im_busy_in) begin
            // hold
        end
        else
        if (!im_busy_in) begin
            if (valid_tmp) begin
                im_data_out <= data_tmp;
                im_valid_out <= valid_tmp;
            end
            else
            if (is_valid_in) begin
                im_data_out  <= is_data_in;
                im_valid_out <= is_valid_in;
            end
            else begin
                im_data_out  <= '0;
                im_valid_out <= 1'b0;
            end
        end
    end
end

always @(posedge clk) begin
    if (!rst_n)
        im_end_out <= 1'b0;
    else begin
        if (im_end_out) begin
            if (!im_busy_in)
                im_end_out <= 1'b0;
        end
        else
        if (is_end_in)
            im_end_out <= 1'b1;
    end
end

always @(posedge clk) begin
    if (!rst_n) begin
        data_tmp <= '0;
        valid_tmp <= 1'b0;
    end
    else begin
        if (valid_tmp)
            if (!im_busy_in)
                valid_tmp <= 1'b0;
        else
        if (is_valid_in & im_busy_in) begin
            data_tmp <= is_data_in;
            valid_tmp <= is_valid_in;
        end
        else
            valid_tmp <= 1'b0;
    end
end

endmodule

`endif
