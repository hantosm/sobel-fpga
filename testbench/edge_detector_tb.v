module edge_detector_tb();

reg clk;
reg rst;
reg [7:0] pixel_in1;
reg [7:0] pixel_in2;
reg [7:0] pixel_in3;
reg [7:0] pixel_in4;
reg [7:0] pixel_in5;
reg [7:0] pixel_in6;
reg [7:0] pixel_in7;
reg [7:0] pixel_in8;
reg [7:0] pixel_in9;
reg hsync, vsync, de;
wire hsync_out, vsync_out, de_out;
wire edge_out;

edge_detector#(
    .THRESHOLD(400)
)edge_detector_u(
    .clk(clk),
    .rst(rst),
    .pixel_in1(pixel_in1),
    .pixel_in2(pixel_in2),
    .pixel_in3(pixel_in3),
    .pixel_in4(pixel_in4),
    .pixel_in5(pixel_in5),
    .pixel_in6(pixel_in6),
    .pixel_in7(pixel_in7),
    .pixel_in8(pixel_in8),
    .pixel_in9(pixel_in9),
    .hsync(hsync),
    .vsync(vsync),
    .de(de),
    .hsync_out(hsync_out),
    .vsync_out(vsync_out),
    .de_out(de_out),
    .edge_out(edge_out)
);
always #5 clk <= ~clk;
initial begin
    clk = 0;
    rst = 1;
    pixel_in1 = 0;
    pixel_in2 = 0;
    pixel_in3 = 0;
    pixel_in4 = 0;
    pixel_in5 = 0;
    pixel_in6 = 0;
    pixel_in7 = 0;
    pixel_in8 = 0;
    pixel_in9 = 0;
    hsync = 0;
    vsync = 0;
    de = 0;


    // test case where all pixels are the same
    #46;
    rst = 0;
    pixel_in1 = 0;
    pixel_in2 = 0;
    pixel_in3 = 0;
    pixel_in4 = 0;
    pixel_in5 = 0;
    pixel_in6 = 0;
    pixel_in7 = 0;
    pixel_in8 = 0;
    pixel_in9 = 0;
    hsync = 0;
    vsync = 0;
    de = 1;
    // test case where there is an edge horizontally
    #10;
    pixel_in1 = 0;
    pixel_in2 = 255;
    pixel_in3 = 255;
    pixel_in4 = 0;
    pixel_in5 = 255;
    pixel_in6 = 255;
    pixel_in7 = 0;
    pixel_in8 = 255;
    pixel_in9 = 255;
    hsync = 0;
    vsync = 0;
    de = 1;

    // test case where there is a difference in pixels, but not an edge
    #10;
    pixel_in1 = 0;
    pixel_in2 = 88;
    pixel_in3 = 0;
    pixel_in4 = 0;
    pixel_in5 = 88;
    pixel_in6 = 0;
    pixel_in7 = 0;
    pixel_in8 = 88;
    pixel_in9 = 0;
    hsync = 0;
    vsync = 0;
    de = 1;

    // test case where there is an edge vertically
    #10;
    pixel_in1 = 0;
    pixel_in2 = 0;
    pixel_in3 = 0;
    pixel_in4 = 255;
    pixel_in5 = 255;
    pixel_in6 = 255;
    pixel_in7 = 255;
    pixel_in8 = 255;
    pixel_in9 = 255;
    hsync = 1;
    vsync = 0;
    de = 1;

    // test case where there is an edge both vertically and horizontally
    #10;
    pixel_in1 = 0;
    pixel_in2 = 0;
    pixel_in3 = 255;
    pixel_in4 = 255;
    pixel_in5 = 255;
    pixel_in6 = 255;
    pixel_in7 = 255;
    pixel_in8 = 255;
    pixel_in9 = 255;
    hsync = 0;
    vsync = 0;
    de = 1;

    // test case where there is a difference in pixels both horizontally and vertically, but not an edge
    #10;
    pixel_in1 = 0;
    pixel_in2 = 0;
    pixel_in3 = 88;
    pixel_in4 = 88;
    pixel_in5 = 88;
    pixel_in6 = 88;
    pixel_in7 = 88;
    pixel_in8 = 88;
    pixel_in9 = 88;
    hsync = 0;
    vsync = 1;
    de = 1;

    // test case where there is an edge from the top left corner
    #10;
    pixel_in1 = 255;
    pixel_in2 = 255;
    pixel_in3 = 255;
    pixel_in4 = 255;
    pixel_in5 = 0;
    pixel_in6 = 0;
    pixel_in7 = 255;
    pixel_in8 = 0;
    pixel_in9 = 0;
    hsync = 0;
    vsync = 0;
    de = 1;

    // test case where there is barely an edge
    #10;
    pixel_in1 = 201;
    pixel_in2 = 201;
    pixel_in3 = 201;
    pixel_in4 = 150;
    pixel_in5 = 150;
    pixel_in6 = 150;
    pixel_in7 = 100;
    pixel_in8 = 100;
    pixel_in9 = 100;
    hsync = 0;
    vsync = 0;
    de = 1;

end

endmodule