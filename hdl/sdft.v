`default_nettype none
module sdft
#(
    parameter data_width = 8, 
    parameter freq_bins = 16,
    parameter FILE_REAL = "hdl/twiddle_real.list",
    parameter FILE_IMAJ = "hdl/twiddle_imag.list"
)
(
    input wire                  clk,
    input wire signed [data_width-1:0] sample
);

    // width of addr needed to address the frequency bins
    localparam bin_addr_w = $clog2(freq_bins);

    // register for the twiddle factor ROM
    reg [bin_addr_w-1:0] twiddle_addr;

    // register for sample index
    reg [bin_addr_w-1:0] sample_index;

    // twiddle factor ROM
    reg signed [data_width-1:0] twiddle_rom_real [freq_bins-1:0];
    reg signed [data_width-1:0] twiddle_rom_imag [freq_bins-1:0];

    initial begin
        if (FILE_REAL) $readmemh(FILE_REAL, twiddle_rom_real);
        if (FILE_IMAJ) $readmemh(FILE_IMAJ, twiddle_rom_imag);
    end

    // frequency bins RAM - double width to handle multiply
    reg signed [data_width*2-1:0] frequency_bins_real [freq_bins-1:0];
    reg signed [data_width*2-1:0] frequency_bins_imag [freq_bins-1:0];

    // sample storage
    reg signed [data_width-1:0] samples [freq_bins-1:0];

    // delta storage (1 more than data_width to handle subtraction)
    reg signed [data_width:0] delta;

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

        for(j = 0; j < freq_bins; j = j + 1)  begin
            frequency_bins_real[j] <= (frequency_bins_real[j] + delta) * twiddle_rom_real[j] - (frequency_bins_imag[j] * twiddle_rom_imag[j]);

            frequency_bins_imag[j] <= frequency_bins_real[j] * twiddle_rom_imag[j] + frequency_bins_imag[j] * twiddle_rom_real[j];
        end
    end

/*
def sdft(delta):
    for i in range(N):
        freqs[i] =  (freqs[i] + delta) * coeffs[i]
*/


endmodule

