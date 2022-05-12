module dp_ram#(
    ADDR_WIDTH = 10,
    DATA_WIDTH = 32    
)(
    input                           clk,

    input                           we,
    input      [ADDR_WIDTH - 1 : 0] wr_addr,
    input      [DATA_WIDTH - 1 : 0] wr_data,
    input      [ADDR_WIDTH - 1 : 0] rd_addr,
    output reg [DATA_WIDTH - 1 : 0] rd_data
);

(* ram_style = "block" *)reg [DATA_WIDTH - 1 : 0] ram [2**ADDR_WIDTH - 1 : 0];
integer i;

initial begin
    for (i = 0; i < 2**ADDR_WIDTH; i = i + 1)
        ram[i] <= 0;
end

always @ (posedge clk) begin
    if (we)
        ram[wr_addr] <= wr_data;
    rd_data <= ram[rd_addr]; 
end

endmodule