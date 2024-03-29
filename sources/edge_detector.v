// edge_detector receives 9 input pixels from line_buffer and returns if there is an edge or not
module edge_detector#(
    THRESHOLD = 100  // subject to change
)(
    input clk,
    input rst,
    input [7:0] pixel_in1,
    input [7:0] pixel_in2,
    input [7:0] pixel_in3,
    input [7:0] pixel_in4,
    input [7:0] pixel_in5,
    input [7:0] pixel_in6,
    input [7:0] pixel_in7,
    input [7:0] pixel_in8,
    input [7:0] pixel_in9,
    input hsync,
    input vsync,
    input de,
    output hsync_out,
    output vsync_out,
    output de_out,
    output reg edge_out
);

// vertical and horizontal sobel filter 
reg signed [10:0] vertical_sobel_out, horizontal_sobel_out;
always @(posedge clk) begin
    if (rst) begin
        vertical_sobel_out <= 0;
        horizontal_sobel_out <= 0;
    end else begin
        vertical_sobel_out <= pixel_in1 + 2*pixel_in2 + pixel_in3 - pixel_in7 - 2*pixel_in8 - pixel_in9;
        horizontal_sobel_out <= pixel_in1 + 2*pixel_in4 + pixel_in7 - pixel_in3 - 2*pixel_in6 - pixel_in9;
    end
end

// if the absolute value of the vertical and horizontal sobel filter is greater than the threshold, then there is an edge
always @(posedge clk) begin
    edge_out <= (vertical_sobel_out > THRESHOLD) || (horizontal_sobel_out > THRESHOLD) || (vertical_sobel_out < -1 * THRESHOLD) || (horizontal_sobel_out < -1 * THRESHOLD);
end

reg [1:0] hsync_dl = 0;
reg [1:0] vsync_dl = 0;
reg [1:0] de_dl = 0;

always @(posedge clk) begin
    if (rst) begin
        hsync_dl <= 0;
        vsync_dl <= 0;
        de_dl <= 0;
    end else begin
        hsync_dl[1:0] <= {hsync_dl[0], hsync};
        vsync_dl[1:0] <= {vsync_dl[0], vsync};
        de_dl[1:0] <= {de_dl[0], de};
    end
end

assign hsync_out = hsync_dl[1];
assign vsync_out = vsync_dl[1];
assign de_out = de_dl[1];

endmodule