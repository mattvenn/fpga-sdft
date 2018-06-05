`default_nettype none
module agu 
#(
    parameter fft_levels = 5,
    parameter butterfly_index = 16,
    parameter max_pair = 32
)
(
    input wire                  clk
);

localparam FFT_W = $clog2(fft_levels);
//localparam BUT_W = $clog2(butterfly_index);
localparam PAIR_W = $clog2(max_pair);

reg [FFT_W-1:0] fft_level;
reg [PAIR_W-1:0] but_level; // must be same width as ja and jb
reg [4-1:0] twiddle_addr;

reg [2*PAIR_W-1:0] ja_rot;  
reg [2*PAIR_W-1:0] jb_rot;

wire [PAIR_W-1:0] ja;  
wire [PAIR_W-1:0] jb;  

assign ja = ja_rot[9:5];
assign jb = jb_rot[9:5];

initial begin
    fft_level = 0;
    but_level = 0;
end

always @(posedge clk) begin

    but_level <= but_level + 1;
    
    if(but_level == butterfly_index - 1) begin
        fft_level <= fft_level + 1;
        but_level <= 0;
        if(fft_level == fft_levels - 1)
            fft_level <= 0;
    end

   // circular rotation:
   // make double length so the left rotation doesn't lose bits
   ja_rot <= {(but_level << 1)       , (but_level << 1)        } << (fft_level);
   jb_rot <= {(but_level << 1) + 1'b1, (but_level << 1) + 1'b1 } << (fft_level);

   twiddle_addr <= but_level & (8'b11110000 >> fft_level);

end

endmodule
