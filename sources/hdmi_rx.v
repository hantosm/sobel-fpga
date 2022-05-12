module hdmi_rx(
   //Clock and reset.
   input  wire       clk_200M,            //200 MHz clock input.
   input  wire       rst,                 //Asynchronous reset signal.
   
   input  wire       hdmi_rx_cec,
   output wire       hdmi_rx_hpd,
   input  wire       hdmi_rx_scl,
   inout  wire       hdmi_rx_sda,
   
   //Input TMDS signals.
   input  wire       hdmi_rx_clk_p,
   input  wire       hdmi_rx_clk_n,
   input  wire       hdmi_rx_d0_p,     //TMDS DATA0 line.
   input  wire       hdmi_rx_d0_n,
   input  wire       hdmi_rx_d1_p,     //TMDS DATA1 line.
   input  wire       hdmi_rx_d1_n,
   input  wire       hdmi_rx_d2_p,     //TMDS DATA2 line.
   input  wire       hdmi_rx_d2_n,
   
   //Output video data.
   output wire       rx_clk,
   output wire       rx_clk_5x,
   output wire [7:0] rx_red,             //Red video signal.
   output wire [7:0] rx_green,           //Green video signal.
   output wire [7:0] rx_blue,            //Blue video signal.
   output wire       rx_dv,              //Blanking signal.
   output wire       rx_hs,              //Horizontal sync signal.
   output wire       rx_vs,           //Vertical sync signal.
   
   //Output status signal.
   output wire [5:0] rx_status
);


endmodule