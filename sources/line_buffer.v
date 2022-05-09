module line_buffer#(
    WIDTH = 1920    
)(
    input        clk,
    input        rst,

    input  [7:0] pixel_in,
    input        hsync,
    input        vsync,
    input        de,

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

reg [7:0] pixel_matrix [9:1];

// State machine to add padding to the incoming picture - TBA
localparam TOP_LEFT = 4'd0;
localparam FIRST_ROW = 4'd1;

wire [7:0] line1;
wire [7:0] line2;

always @ (posedge clk) begin
    pixel_matrix[9] <= pixel_in;
    pixel_matrix[8] <= pixel_matrix[9];
    pixel_matrix[7] <= pixel_matrix[8];
    
    pixel_matrix[6] <= line1;
    pixel_matrix[5] <= pixel_matrix[6];
    pixel_matrix[4] <= pixel_matrix[5];

    pixel_matrix[3] <= line2;
    pixel_matrix[2] <= pixel_matrix[3];
    pixel_matrix[1] <= pixel_matrix[2];
end


line_delay#(
    .LINE_WIDTH (WIDTH - 3),
    .DATA_WIDTH (8)
)linedl_1(
    .clk               ( clk             ),
    .rst               ( rst             ),
    .pixel_in          ( pixel_matrix[7] ),
    .data_valid        ( 1'b1      ),
    .pixel_out         ( line1           )
);

line_delay#(
    .LINE_WIDTH (WIDTH - 3),
    .DATA_WIDTH (8)
)linedl_2(
    .clk               ( clk             ),
    .rst               ( rst             ),
    .pixel_in          ( pixel_matrix[4] ),
    .data_valid        ( 1'b1            ),
    .pixel_out         ( line2           )
);

// Output assignment
assign pixel_out1 = de ? pixel_matrix[1] : 0;
assign pixel_out2 = de ? pixel_matrix[2] : 0;
assign pixel_out3 = de ? pixel_matrix[3] : 0;
assign pixel_out4 = de ? pixel_matrix[4] : 0;
assign pixel_out5 = de ? pixel_matrix[5] : 0;
assign pixel_out6 = de ? pixel_matrix[6] : 0;
assign pixel_out7 = de ? pixel_matrix[7] : 0;
assign pixel_out8 = de ? pixel_matrix[8] : 0;
assign pixel_out9 = de ? pixel_matrix[9] : 0;

endmodule