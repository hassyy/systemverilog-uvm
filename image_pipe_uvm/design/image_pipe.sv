`ifndef __IMAGE_PIPE__
    `define __IMAGE_PIPE__

module image_pipe(
    input wire clk
    , input wire rst_n
    , input wire [31:0] is_data_in     // Slave IF
    , input wire is_valid_in
    , output reg is_busy_out
    , output reg[31:0]  im_data_out    // Master IF
    , output reg im_valid_out
    , input wire im_busy_in
    );

// Slave IF
always @(posedge clk) begin
    if (!rst_n) is_busy_out <= '0;
    else if (!im_busy_in) im_data_out <= is_data_in;
end

// Master IF
always @(posedge clk) begin
    if (!rst_n) begin
        im_data_out  <= '0;
        im_valid_out <= '0;
    end else begin
        if (!im_busy_in) begin
            im_data_out  <= is_data_in + 1;
            im_valid_out<= is_valid_in;
        end
    end
end

endmodule

`endif
