module line_delay_tb();

reg clk;
reg rst;
reg [7:0] pixel_in;
reg data_valid;

wire [7:0] pixel_out;

localparam WIDTH = 20;
localparam WIDTH_VISIBLE = 12;
localparam HSYNC_FP = 2;
localparam HSYNC_PW = 1;
localparam HSYNC_BP = 5;

localparam DEPTH = 10;
localparam DEPTH_VISIBLE = 5;
localparam VSYNC_FP = 1;
localparam VSYNC_PW = 1;
localparam VSYNC_BP = 2;

reg [10:0] h_cntr;
reg [10:0] v_cntr;
wire hsync_rise;
reg hsync;
reg vsync;
reg de;

wire [7:0] data_in;
assign data_in = de ? pixel_in : 0;

line_delay#(
    .LINE_WIDTH(2 * WIDTH),
    .DATA_WIDTH(8)
)u_line_delay(
    .clk               ( clk       ),
    .rst               ( hsync_rise || rst   ),
    .data_in           ( data_in  ),
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

always @ (posedge clk) begin
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

always @(*) begin
    hsync <= ((h_cntr >= WIDTH_VISIBLE + HSYNC_FP) && (h_cntr <= WIDTH_VISIBLE + HSYNC_FP + HSYNC_PW));
    vsync <= ((v_cntr >= DEPTH_VISIBLE + VSYNC_FP) && (v_cntr <= DEPTH_VISIBLE + VSYNC_FP + VSYNC_PW));
    de <= ((h_cntr >= 0 && h_cntr < WIDTH_VISIBLE) && (v_cntr >= 0 && v_cntr < DEPTH_VISIBLE));
end

assign hsync_rise = (h_cntr == WIDTH_VISIBLE + HSYNC_FP);

initial begin
    clk = 0;
    rst = 1;
    pixel_in = 0;

    #7;
    rst = 0;
end

endmodule