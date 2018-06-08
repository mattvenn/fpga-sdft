`default_nettype none
module test;

    reg reset = 0;
    reg signed [15:0] sample = 0;

    wire [15:0]freqs_0 ;
    wire [15:0]freqs_1;

    integer i;
    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0,test);
        for (i = 0 ; i < 16 ; i = i + 1) begin
            $dumpvars(1, dut.samples[i]);
            $dumpvars(2, dut.frequency_bins_real[i]);
            $dumpvars(3, dut.frequency_bins_imag[i]);
            $dumpvars(4, dut.twiddle_rom_real[i]);
            $dumpvars(5, dut.twiddle_rom_imag[i]);
        end
        /*
        for (i = 0; i < 100; i = i + 1) begin
            sample <= 1;
            # 2;
            sample <= 2;
            # 2;
            sample <= 3;
            # 2;
            sample <= 4;
            # 2;
            sample <= 5;
            # 2;
            sample <= 6;
            # 2;
            sample <= 7;
            # 2;
        end
        */
        for (i = 0; i < 20; i = i + 1) begin
            sample <= -10;
            # 2;
            sample <= +10;
            # 2;
        end
        $finish;
    end

    // clock
    reg clk = 0;
    always #1 clk = !clk;

    sdft #( .data_width(8), .freq_bins(16)) dut(.clk (clk), .sample(sample), .freqs_0(freqs_0), .freqs_1(freqs_1));

endmodule // test
