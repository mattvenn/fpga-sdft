`default_nettype none

module top (
	input  clk,
    output LED,
    input [7:0] adc,
    output adc_clk,
    output hsync,
    output vsync,
    output vga_r,
    output vga_g,
    output vga_b

);

    localparam freq_bins = 16;
    localparam freq_data_w = 16;
    localparam bin_addr_w = $clog2(freq_bins);
    reg [bin_addr_w:0] bin_addr;
    localparam screen_height = 480;
    localparam bar_height = screen_height / freq_bins;
    localparam bar_height_counter_w = $clog2(bar_height);

    reg [10:0] update_counter = 0; // when this wraps we update the frequency bins

    integer i;

    wire [9:0] x_px;
    wire [9:0] y_px;
    wire signed [freq_data_w-1:0] bin_out_imag;
    wire signed [freq_data_w-1:0] bin_out_real;
    wire fft_ready;
    reg fft_start;
    reg fft_read;

    reg [7:0] sample;

    //sdft #( .data_width(8), .freq_bins(freq_bins)) sdft_0(.clk (adc_clk), .sample(sample), .ready(fft_ready), .start(fft_start), .read(fft_read), .bin_out_real(bin_out_real), .bin_out_imag(bin_out_imag)); 

    wire px_clk;
    wire activevideo;
    wire draw_bar;
    assign vga_g = activevideo && draw_bar;
    assign vga_r = activevideo && draw_bar;
    assign vga_b = activevideo && draw_bar;

    VgaSyncGen vga_inst( .clk(clk), .hsync(hsync), .vsync(vsync), .x_px(x_px), .y_px(y_px), .px_clk(px_clk), .activevideo(activevideo));

    wire [bin_addr_w:0] freq_bram_w_addr;
    wire [bin_addr_w:0] freq_bram_r_addr;
    wire [freq_data_w-1:0] freq_bram_out;
    wire [freq_data_w-1:0] freq_bram_in;
    reg freq_bram_w; // write enable signal
    wire freq_bram_r; // read enable signal
    wire freq_bram_r_clk;
    wire freq_bram_w_clk;

    freq_bram #(.addr_w(bin_addr_w), .data_w(freq_data_w)) freq_bram_0(.w_clk(freq_bram_w_clk), .r_clk(freq_bram_r_clk), .w_en(freq_bram_w), .r_en(freq_bram_r), .d_in(freq_bram_in), .d_out(freq_bram_out), .r_addr(freq_bram_r_addr), .w_addr(freq_bram_w_addr));

/*
    reg [3:0] state = STATE_START;
    // sample data as fast as possible
    always @(posedge adc_clk) begin
        update_counter <= update_counter + 1;
        if(update_counter == 0 && fft_ready) begin
            bin_addr <= bin_addr + 1;
            fft_read <= 1;
            if(bin_addr == freq_bins -1)
                bin_addr <= 0;

            // store the squared bin value to BRAM
            freq_bram_in <= (bin_out_real * bin_out_real) + (bin_out_imag * bin_out_imag) >> 8; // some divider here
            bram_w <= 1;

        elif(fft_ready) begin
            sample <= adc;
            fft_start <= 1'b1;
        end
        else begin
            fft_start <= 1'b0;
            fft_read <= 1'b0;
        end
    end
*/
    
    // bram addr is calculated from y_px
    assign freq_bram_r_addr = y_px / bar_height;
    // request new value at top of bar and left side of screen
    wire start_of_screen = y_px == 0 && x_px == 0 && activevideo;
    wire start_of_line = x_px == 0 && activevideo;
    assign freq_bram_r = bar_height_counter == 0 && start_of_line;
    // draw the bar if the x_px is below the frequency value
    assign draw_bar = x_px < freq_bram_out;
    assign freq_bram_r_clk = px_clk;
    reg [bar_height_counter_w:0] bar_height_counter = 0;

    // increment bar_height_counter every new line, reset to 0 at top of the screen and after every bar
    always@(posedge start_of_line) begin
        bar_height_counter <= bar_height_counter + 1;
        if(start_of_screen)
            bar_height_counter <= 0;
        else if(bar_height_counter == bar_height - 1)
            bar_height_counter <= 0;
    end

endmodule
