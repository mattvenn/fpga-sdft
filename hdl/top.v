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

    wire [15:0] freqs_0;
    wire [15:0] freqs_1;
    wire [15:0] freqs_2;
    wire [15:0] freqs_3;
    wire [15:0] freqs_4;
    wire [15:0] freqs_5;
    wire [15:0] freqs_6;
    wire [15:0] freqs_7;
    wire [15:0] freqs_8;
    wire [15:0] freqs_9;
    wire [15:0] freqs_10;
    wire [15:0] freqs_11;
    wire [15:0] freqs_12;
    wire [15:0] freqs_13;
    wire [15:0] freqs_14;
    wire [15:0] freqs_15;

    sdft #( .data_width(8), .freq_bins(16)) sdft_0(.clk (adc_clk), .sample(sample), 
        .freqs_0(freqs_0), 
        .freqs_1(freqs_1),
        .freqs_2(freqs_2),
        .freqs_3(freqs_3),
        .freqs_4(freqs_4),
        .freqs_5(freqs_5),
        .freqs_6(freqs_6),
        .freqs_7(freqs_7),
        .freqs_8(freqs_8),
        .freqs_9(freqs_9),
        .freqs_10(freqs_10),
        .freqs_11(freqs_11),
        .freqs_12(freqs_12),
        .freqs_13(freqs_13),
        .freqs_14(freqs_14),
        .freqs_15(freqs_15)
        
        ); 

    VgaSyncGen vga_inst( .clk(clk), .hsync(hsync), .vsync(vsync), .x_px(x_px), .y_px(y_px), .px_clk(px_clk), .activevideo(activevideo));

    assign g = r;
    assign b = r;
   
    assign r = (y_px > 0  && y_px < 10 && x_px < freqs_0); 
    assign r = (y_px > 10 && y_px < 20 && x_px < freqs_1); 
    assign r = (y_px > 20 && y_px < 30 && x_px < freqs_2); 
    assign r = (y_px > 30 && y_px < 40 && x_px < freqs_3); 
    assign r = (y_px > 40 && y_px < 50 && x_px < freqs_4); 
    assign r = (y_px > 50 && y_px < 60 && x_px < freqs_5); 
    assign r = (y_px > 60 && y_px < 70 && x_px < freqs_6); 
    assign r = (y_px > 70 && y_px < 80 && x_px < freqs_7); 
    assign r = (y_px > 80 && y_px < 90 && x_px < freqs_8); 
    assign r = (y_px > 90 && y_px < 100 && x_px < freqs_9); 
    assign r = (y_px > 100 && y_px < 110 && x_px < freqs_10); 
    assign r = (y_px > 110 && y_px < 120 && x_px < freqs_11); 
    assign r = (y_px > 120 && y_px < 130 && x_px < freqs_12); 
    assign r = (y_px > 130 && y_px < 140 && x_px < freqs_13); 
    assign r = (y_px > 140 && y_px < 150 && x_px < freqs_14); 
    assign r = (y_px > 150 && y_px < 160 && x_px < freqs_15); 
                


endmodule
