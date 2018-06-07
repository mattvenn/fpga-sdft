`default_nettype none
module test;

    reg reset = 0;
    reg signed [7:0] sample = 0;

    integer i;
    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0,test);
        for (i = 0 ; i < 16 ; i = i + 1) begin
            $dumpvars(1, dut.samples[i]);
            $dumpvars(2, dut.frequency_bins_real[i]);
            $dumpvars(3, dut.frequency_bins_imag[i]);
        end
        for (i = 0; i < 100; i = i + 1) begin
            sample <= -1;
            # 4;
            sample <= +1;
            # 4;
        end
        $finish;
    end

    // clock
    reg clk = 0;
    always #1 clk = !clk;

    sdft #( .data_width(8), .freq_bins(16)) dut(.clk (clk), .sample(sample)); 

endmodule // test
