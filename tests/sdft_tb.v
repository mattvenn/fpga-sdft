`default_nettype none
module test;

    reg reset = 0;
    reg signed [7:0] sample = 0;
    reg start = 0;
    wire ready;

    localparam bins = 128;

    integer i, j;
    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0,test);
        for (i = 0 ; i < bins ; i = i + 1) begin
            $dumpvars(1, dut.samples[i]);
            $dumpvars(2, dut.frequency_bins_real[i]);
            $dumpvars(3, dut.frequency_bins_imag[i]);
        end

        for (i = 0; i < 2; i = i + 1) begin
            for (j = 0; j < bins/2; j = j + 1) begin
                $display("cycle: %d %d", j, sample);
                sample <= -100;
                start <= 1;
                wait(ready == 0);
                start <= 0;
                wait(ready == 1);
            end
            for (j = 0; j < bins/2; j = j + 1) begin
                $display("cycle: %d %d", j, sample);
                sample <= +100;
                start <= 1;
                wait(ready == 0);
                start <= 0;
                wait(ready == 1);
            end
        end
        $finish;
    end

    // clock
    reg clk = 0;
    always #1 clk = !clk;

    sdft #( .data_width(8), .freq_bins(bins)) dut(.clk (clk), .sample(sample), .start(start), .ready(ready));
       

endmodule // test
