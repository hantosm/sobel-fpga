module line_buffer#(
    WIDTH = 2100
)(
    input        clk,
    input        rst,

    input  [7:0] pixel_in,
    input        hsync,
    input        vsync,
    input        de,

    output       hsync_dl,
    output       vsync_dl,
    output       de_dl,

    output [7:0] pixel_out1,
    output [7:0] pixel_out2,
    output [7:0] pixel_out3,
    output [7:0] pixel_out4,
    output [7:0] pixel_out5,
    output [7:0] pixel_out6,
    output [7:0] pixel_out7,
    output [7:0] pixel_out8,
    output [7:0] pixel_out9
);

// Delay video control signals to detect hsync rising edge
reg [1:0] hsync_dl1;
reg [1:0] vsync_dl1;
reg [1:0] de_dl1;

always @ (posedge clk) begin
    hsync_dl1 <= {hsync_dl1[1:0], hsync};
    vsync_dl1 <= {vsync_dl1[1:0], vsync};
    de_dl1    <= {de_dl1[1:0], de};
end

// Hsync rising edge is the reset signal for the line delay modules
wire hsync_rise;
assign hsync_rise = (~hsync_dl1[0] && hsync);

// Output pixel matrix
(* ram_style = "registers" *) reg [7:0] pixel_matrix [9:1];

wire [7:0] line1;
wire [7:0] line2;

integer i;
always @ (posedge clk) begin
    if (rst) begin
        for (i = 1; i < 9; i = i + 1)
            pixel_matrix[i] <= 0;
    end
    else begin
        pixel_matrix[9] <= de ? pixel_in : 8'h00;
        pixel_matrix[8] <= pixel_matrix[9];
        pixel_matrix[7] <= pixel_matrix[8];
        
        pixel_matrix[6] <= line1;
        pixel_matrix[5] <= pixel_matrix[6];
        pixel_matrix[4] <= pixel_matrix[5];

        pixel_matrix[3] <= line2;
        pixel_matrix[2] <= pixel_matrix[3];
        pixel_matrix[1] <= pixel_matrix[2];
    end
end

wire [7:0] line1_in;
assign line1_in = de ? pixel_in : 8'h00;

line_delay#(
    .LINE_WIDTH (WIDTH),
    .DATA_WIDTH (8)
)linedl_1(
    .clk               ( clk        ),
    .rst               ( hsync_rise ),
    .data_in           ( line1_in   ),
    .data_valid        ( 1'b1       ),
    .data_out          ( line1      )
);

line_delay#(
    .LINE_WIDTH (WIDTH),
    .DATA_WIDTH (8)
)linedl_2(
    .clk               ( clk        ),
    .rst               ( hsync_rise ),
    .data_in           ( line1      ),
    .data_valid        ( 1'b1       ),
    .data_out          ( line2      )
);

// Delay video control signals to align with output pixel
wire [2:0] video_control;
wire [2:0] video_control_dl;

assign video_control = {de_dl1[1], vsync_dl1[1], hsync_dl1[1]};

line_delay#(
    .LINE_WIDTH (WIDTH + 3),
    .DATA_WIDTH (3)
)videoctrl_dl(
    .clk               ( clk              ),
    .rst               ( hsync_rise       ),
    .data_in           ( video_control    ),
    .data_valid        ( 1'b1             ),
    .data_out          ( video_control_dl )
);

// Output assignment
assign pixel_out1 = pixel_matrix[1];
assign pixel_out2 = pixel_matrix[2];
assign pixel_out3 = pixel_matrix[3];
assign pixel_out4 = pixel_matrix[4];
assign pixel_out5 = pixel_matrix[5];
assign pixel_out6 = pixel_matrix[6];
assign pixel_out7 = pixel_matrix[7];
assign pixel_out8 = pixel_matrix[8];
assign pixel_out9 = pixel_matrix[9];

assign hsync_dl = video_control_dl[0];
assign vsync_dl = video_control_dl[1];
assign de_dl    = video_control_dl[2];

endmodule