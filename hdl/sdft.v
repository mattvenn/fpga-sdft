`default_nettype none
module sdft
#(
    parameter data_width = 8, 
    parameter freq_bins = 16,
    parameter FILE_REAL = "hdl/twiddle_real.list",
    parameter FILE_IMAJ = "hdl/twiddle_imag.list"
)
(
    input wire                              clk,
    input wire signed [data_width*2-1:0]    sample,
    output wire [15:0]                      freqs_0,
    output wire [15:0]                      freqs_1,
    output wire [15:0]                      freqs_2,
    output wire [15:0]                      freqs_3,
    output wire [15:0]                      freqs_4,
    output wire [15:0]                      freqs_5,
    output wire [15:0]                      freqs_6,
    output wire [15:0]                      freqs_7,
    output wire [15:0]                      freqs_8,
    output wire [15:0]                      freqs_9,
    output wire [15:0]                      freqs_10,
    output wire [15:0]                      freqs_11,
    output wire [15:0]                      freqs_12,
    output wire [15:0]                      freqs_13,
    output wire [15:0]                      freqs_14,
    output wire [15:0]                      freqs_15
);


    // width of addr needed to address the frequency bins
    localparam bin_addr_w = $clog2(freq_bins);

    // register for the twiddle factor ROM
    reg [bin_addr_w-1:0] twiddle_addr;

    // register for sample index
    reg [bin_addr_w-1:0] sample_index;

    // twiddle factor ROM
    reg signed [16-1:0] twiddle_rom_real [freq_bins-1:0];
    reg signed [16-1:0] twiddle_rom_imag [freq_bins-1:0];

    // frequency bins RAM - double width to handle multiply
    reg signed [data_width*2-1:0] frequency_bins_real [freq_bins-1:0];
    reg signed [data_width*2-1:0] frequency_bins_imag [freq_bins-1:0];

    // this assignment has to happen after RAM declaration
    assign freqs_0 = frequency_bins_imag[0] + 128;
    assign freqs_1 = frequency_bins_imag[1] + 128;
    assign freqs_2 = frequency_bins_imag[2] + 128;
    assign freqs_3 = frequency_bins_imag[3] + 128;
    assign freqs_4 = frequency_bins_imag[4] + 128;
    assign freqs_5 = frequency_bins_imag[5] + 128;
    assign freqs_6 = frequency_bins_imag[6] + 128;
    assign freqs_7 = frequency_bins_imag[7] + 128;
    assign freqs_8 = frequency_bins_imag[8] + 128;
    assign freqs_9 = frequency_bins_imag[9] + 128;
    assign freqs_10 = frequency_bins_imag[10] + 128;
    assign freqs_11 = frequency_bins_imag[11] + 128;
    assign freqs_12 = frequency_bins_imag[12] + 128;
    assign freqs_13 = frequency_bins_imag[13] + 128;
    assign freqs_14 = frequency_bins_imag[14] + 128;
    assign freqs_15 = frequency_bins_imag[15] + 128;

    initial begin
        $readmemh(FILE_REAL, twiddle_rom_real);
        $readmemh(FILE_IMAJ, twiddle_rom_imag);
    end


    // sample storage
    reg signed [data_width*2-1:0] samples [freq_bins-1:0];

    // delta storage (1 more than data_width to handle subtraction)
    reg signed [data_width*2-1:0] delta;

    integer j;
    initial begin
        twiddle_addr = 0;
        sample_index = 0;
        delta = 0;
        for(j = 0; j < freq_bins; j = j + 1)  begin
            samples[j] = 0;
            frequency_bins_real[j] = 0;
            frequency_bins_imag[j] = 0;
        end

    end


    always @(posedge clk) begin
        // get delta: newest - oldest
        delta <= sample - samples[sample_index];
        // store new sample
        samples[sample_index] <= sample;
        // increment sample index (same as rotating)
        sample_index <= sample_index + 1;
        // reset index if it wraps
        if(sample_index == freq_bins)
            sample_index <= 0;

        

        //x1 + j * y1
        //x2 + j * y2

        //x1 * x2 – y1 * y2
        //x1 * y2 + x2 * y1

        
        for(j = 0; j < freq_bins; j = j + 1)  begin
            // delta is only real, so can skip adding it to the imag parts
            frequency_bins_real[j] <= ((frequency_bins_real[j] + delta) * twiddle_rom_real[j] - (frequency_bins_imag[j] * twiddle_rom_imag[j])) >>> 7;

            frequency_bins_imag[j] <= ((frequency_bins_real[j] + delta) * twiddle_rom_imag[j] + (frequency_bins_imag[j] * twiddle_rom_real[j])) >>> 7;

        end
        /*
        freqs_0 <= frequency_bins_imag[0][0];
        freqs_1 <= frequency_bins_imag[1][0];
        */
    end

/*
def sdft(delta):
    for i in range(N):
        freqs[i] =  (freqs[i] + delta) * coeffs[i]
*/


endmodule

