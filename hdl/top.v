`default_nettype none

module top (
	input  clk,
    input [3:0] g,
    output LED
    
);
    wire signed [7:0] sample;
    assign sample = g;

    sdft #( .data_width(8), .freq_bins(16)) dut(.clk (clk), .sample(sample), .out(LED)); 

endmodule

