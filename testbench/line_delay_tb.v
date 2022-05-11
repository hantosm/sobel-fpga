module line_delay_tb();

reg clk;
reg rst;
reg [5:0] pixel_in;
reg data_valid;

wire [5:0] pixel_out;

localparam WIDTH = 10;
localparam DEPTH = 5;

reg [3:0] h_cntr;
reg [2:0] v_cntr;

line_delay#(
    .LINE_WIDTH(WIDTH),
    .DATA_WIDTH(6)
)u_line_delay(
    .clk               ( clk       ),
    .rst               ( rst       ),
    .data_in           ( pixel_in  ),
    .data_valid        ( 1'b1      ),
    .data_out          ( pixel_out )
);

always #2 clk <= ~clk;
always @ (posedge clk) begin
    if (rst || h_cntr == WIDTH - 1)
        h_cntr <= 0;
    else
        h_cntr <= h_cntr + 1;
end

always @(posedge clk) begin
    if (rst)
        v_cntr <= 0;
    else if (h_cntr == WIDTH - 1) begin
        if (v_cntr == DEPTH - 1)
            v_cntr <= 0;
        else
            v_cntr <= v_cntr + 1;
    end
end

always @ (negedge clk) begin
    if (rst)
        pixel_in <= 0;
    else
        pixel_in <= h_cntr + v_cntr * WIDTH;
end

initial begin
    clk = 0;
    rst = 1;
    pixel_in = 0;

    #7;
    rst = 0;
end

endmodule