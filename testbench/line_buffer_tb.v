module line_buffer_tb();

// Input registers
reg clk;
reg rst;
reg [7:0] pixel_in;
reg hsync;
reg vsync;
reg de;

wire [7:0] pixel_out [9:1];
wire hsync_dl;
wire vsync_dl;
wire de_dl;

localparam WIDTH = 10;
localparam DEPTH = 5;
reg [3:0] h_cntr;
reg [2:0] v_cntr;


line_buffer#(
    .WIDTH(10)
)u_line_buffer(
    .clk          ( clk          ),
    .rst          ( rst          ),
    .pixel_in     ( pixel_in     ),
    .hsync        ( hsync        ),
    .vsync        ( vsync        ),
    .de           ( de           ),
    .de_dl        ( de_dl        ),
    .hsync_dl     ( hsync_dl     ),
    .vsync_dl     ( vsync_dl     ),
    .pixel_out1   ( pixel_out[1] ),
    .pixel_out2   ( pixel_out[2] ),
    .pixel_out3   ( pixel_out[3] ),
    .pixel_out4   ( pixel_out[4] ),
    .pixel_out5   ( pixel_out[5] ),
    .pixel_out6   ( pixel_out[6] ),
    .pixel_out7   ( pixel_out[7] ),
    .pixel_out8   ( pixel_out[8] ),
    .pixel_out9   ( pixel_out[9] )
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

always #1 if (pixel_in == 20'd30)
            hsync <= 1'b1;
        else hsync <= 1'b0;

initial begin
    clk = 0;
    rst = 1;
    de = 1;

    #21;
    rst = 0;
end

endmodule