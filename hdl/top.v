`default_nettype none

module top (
	input  clk,
    output LED,
    input [7:0] adc,
    output adc_clk,
    output hsync,
    output vsync,
    output r,
    output g,
    output b

);

    wire [9:0] x_px;
    wire [9:0] y_px;
    wire px_clk;
    wire activevideo;

    reg [7:0] sample;
    
    // sample once per screen update
    assign adc_clk = vsync;
    always @(posedge adc_clk)
        sample <= adc;

    wire [22:0] freqs_0;

    sdft #( .data_width(8), .freq_bins(16)) sdft_0(.clk (adc_clk), .sample(sample)); 

    VgaSyncGen vga_inst( .clk(clk), .hsync(hsync), .vsync(vsync), .x_px(x_px), .y_px(y_px), .px_clk(px_clk), .activevideo(activevideo));

    assign g = r;
    assign b = r;
   
    assign r = (y_px > 0  && y_px < 10 && x_px < freqs_0) ;


endmodule
