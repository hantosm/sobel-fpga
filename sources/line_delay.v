module line_delay #(
    LINE_WIDTH = 1920,
    DATA_WIDTH = 8
)(
    input                     clk,
    input                     rst,

    input  [DATA_WIDTH - 1:0] data_in,
    input                     data_valid,

    output [DATA_WIDTH - 1:0] data_out
);

reg [$clog2(LINE_WIDTH) - 1:0] wr_ptr;
reg [$clog2(LINE_WIDTH) - 1:0] rd_ptr;

// write address construction
always @(posedge clk ) begin
    if (data_valid)
        wr_ptr <= rd_ptr;
end

// read address construction
always @(posedge clk) begin
    if (rst)
        rd_ptr <= 0;
    else if (data_valid)
        // if (rd_ptr == LINE_WIDTH - 1)
        //     rd_ptr <= 0;
        // else
            rd_ptr <= rd_ptr + 1'b1;
end

dp_ram #(
    .ADDR_WIDTH($clog2(LINE_WIDTH)),
    .DATA_WIDTH(DATA_WIDTH)
) u_dp_ram(
    .clk      ( clk        ),
    .we       ( data_valid ),
    .wr_addr  ( wr_ptr     ),
    .wr_data  ( data_in    ),
    .rd_addr  ( rd_ptr     ),
    .rd_data  ( data_out   )
);

endmodule