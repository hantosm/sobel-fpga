// this is a wrapper for sobel edge detection
// it uses dp_ram, edge_detector, line_buffer, and line_delay modules
// the wrapper receives 24 bit color image and produces 24 bit edge image
// inside the wrapper the modules are created 3 times, for r, g, b channels
module sobel_wrapper#(
    MAX_LINE_WIDTH = 2100
)(
    input         clk,
    input         rst,

    input [23:0]  rgb_in,
    input         hsync,
    input         vsync,
    input         de,    

    output [23:0] edge_out,
    output        hsync_out,
    output        vsync_out,
    output        de_out
);

wire [2:0] hsync_dl, vsync_dl, de_dl;
wire [7:0] pixel_out_r [9:1];
wire [7:0] pixel_out_g [9:1];
wire [7:0] pixel_out_b [9:1];

line_buffer#(
    .WIDTH(MAX_LINE_WIDTH)
) line_buffer_r(
    .clk(clk),
    .rst(rst),

    .pixel_in(rgb_in[7:0]),
    .hsync(hsync),
    .vsync(vsync),
    .de(de),

    .pixel_out1(pixel_out_r[1]),
    .pixel_out2(pixel_out_r[2]),
    .pixel_out3(pixel_out_r[3]),
    .pixel_out4(pixel_out_r[4]),
    .pixel_out5(pixel_out_r[5]),
    .pixel_out6(pixel_out_r[6]),
    .pixel_out7(pixel_out_r[7]),
    .pixel_out8(pixel_out_r[8]),
    .pixel_out9(pixel_out_r[9]),

    .hsync_dl(hsync_dl[0]),
    .vsync_dl(vsync_dl[0]),
    .de_dl(de_dl[0])

);

line_buffer#(
    .WIDTH(MAX_LINE_WIDTH)
) line_buffer_g(
    .clk(clk),
    .rst(rst),

    .pixel_in(rgb_in[15:8]),
    .hsync(hsync),
    .vsync(vsync),
    .de(de),

    .pixel_out1(pixel_out_g[1]),
    .pixel_out2(pixel_out_g[2]),
    .pixel_out3(pixel_out_g[3]),
    .pixel_out4(pixel_out_g[4]),
    .pixel_out5(pixel_out_g[5]),
    .pixel_out6(pixel_out_g[6]),
    .pixel_out7(pixel_out_g[7]),
    .pixel_out8(pixel_out_g[8]),
    .pixel_out9(pixel_out_g[9]),

    .hsync_dl(hsync_dl[1]),
    .vsync_dl(vsync_dl[1]),
    .de_dl(de_dl[1])

);

line_buffer#(
    .WIDTH(MAX_LINE_WIDTH)
) line_buffer_b(
    .clk(clk),
    .rst(rst),

    .pixel_in(rgb_in[23:16]),
    .hsync(hsync),
    .vsync(vsync),
    .de(de),

    .pixel_out1(pixel_out_b[1]),
    .pixel_out2(pixel_out_b[2]),
    .pixel_out3(pixel_out_b[3]),
    .pixel_out4(pixel_out_b[4]),
    .pixel_out5(pixel_out_b[5]),
    .pixel_out6(pixel_out_b[6]),
    .pixel_out7(pixel_out_b[7]),
    .pixel_out8(pixel_out_b[8]),
    .pixel_out9(pixel_out_b[9]),

    .hsync_dl(hsync_dl[2]),
    .vsync_dl(vsync_dl[2]),
    .de_dl(de_dl[2])

);

wire edge_out_r, edge_out_g, edge_out_b;

edge_detector#(
    .THRESHOLD(400)
)edge_detector_r(
    .clk(clk),
    .rst(rst),
    .pixel_in1(pixel_out_r[1]),
    .pixel_in2(pixel_out_r[2]),
    .pixel_in3(pixel_out_r[3]),
    .pixel_in4(pixel_out_r[4]),
    .pixel_in5(pixel_out_r[5]),
    .pixel_in6(pixel_out_r[6]),
    .pixel_in7(pixel_out_r[7]),
    .pixel_in8(pixel_out_r[8]),
    .pixel_in9(pixel_out_r[9]),
    .hsync(hsync_dl[0]),
    .vsync(vsync_dl[0]),
    .de(de_dl[0]),

    .hsync_out(hsync_out),
    .vsync_out(vsync_out),
    .de_out(de_out),
    .edge_out(edge_out_r)
);

edge_detector#(
    .THRESHOLD(400)
)edge_detector_g(
    .clk(clk),
    .rst(rst),
    .pixel_in1(pixel_out_g[1]),
    .pixel_in2(pixel_out_g[2]),
    .pixel_in3(pixel_out_g[3]),
    .pixel_in4(pixel_out_g[4]),
    .pixel_in5(pixel_out_g[5]),
    .pixel_in6(pixel_out_g[6]),
    .pixel_in7(pixel_out_g[7]),
    .pixel_in8(pixel_out_g[8]),
    .pixel_in9(pixel_out_g[9]),
    .hsync(hsync_dl[1]),
    .vsync(vsync_dl[1]),
    .de(de_dl[1]),

    .hsync_out(),
    .vsync_out(),
    .de_out(),
    .edge_out(edge_out_g)
);

edge_detector#(
    .THRESHOLD(400)
)edge_detector_b(
    .clk(clk),
    .rst(rst),
    .pixel_in1(pixel_out_b[1]),
    .pixel_in2(pixel_out_b[2]),
    .pixel_in3(pixel_out_b[3]),
    .pixel_in4(pixel_out_b[4]),
    .pixel_in5(pixel_out_b[5]),
    .pixel_in6(pixel_out_b[6]),
    .pixel_in7(pixel_out_b[7]),
    .pixel_in8(pixel_out_b[8]),
    .pixel_in9(pixel_out_b[9]),
    .hsync(hsync_dl[2]),
    .vsync(vsync_dl[2]),
    .de(de_dl[2]),

    .hsync_out(),
    .vsync_out(),
    .de_out(),
    .edge_out(edge_out_b)
);

assign edge_out = {24{edge_out_b | edge_out_g | edge_out_r}};
endmodule