module hdmi_tx(
   //Clock and reset.
   input  wire       tx_clk,              //Pixel clock input.
   input  wire       tx_clk_5x,           //5x pixel clock input.
   input  wire       rst,                 //Reset signal.
   
   //Input video data.
   input  wire [7:0] tx_red,              //Red video signal.
   input  wire [7:0] tx_green,            //Green video signal.
   input  wire [7:0] tx_blue,             //Blue video signal.
   input  wire       tx_dv,            //Blanking signal.
   input  wire       tx_hs,            //Horizontal sync signal.
   input  wire       tx_vs,            //Vertical sync signal.
   
   //Output TMDS signals.
   output wire       hdmi_tx_clk_p,    //TMDS CLOCK line.
   output wire       hdmi_tx_clk_n,
   output wire       hdmi_tx_d0_p,    //TMDS DATA0 line.
   output wire       hdmi_tx_d0_n,
   output wire       hdmi_tx_d1_p,    //TMDS DATA1 line.
   output wire       hdmi_tx_d1_n,
   output wire       hdmi_tx_d2_p,    //TMDS DATA2 line.
   output wire       hdmi_tx_d2_n
);


endmodule