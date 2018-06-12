`default_nettype none
module test;

    reg reset = 0;
    reg signed [7:0] sample = 0;
    reg start = 0;
    reg read = 0;
    reg [bin_addr_w-1:0] bin_addr = 0;

    wire ready;
    wire [22:0] out_imag;
    wire [22:0] out_real;

    localparam bins = 128;
    localparam bin_addr_w = $clog2(bins);

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

        // read some values
        bin_addr <= 0;
        read <= 1;
        wait(ready == 0);
        read <= 0;
        # 4
        bin_addr <= 1;
        read <= 1;
        wait(ready == 0);
        read <= 0;
        # 4

        $finish;
    end

    // clock
    reg clk = 0;
    always #1 clk = !clk;

    sdft #( .data_width(8), .freq_bins(bins)) dut(.clk (clk), .sample(sample), .start(start), .ready(ready), .bin_addr(bin_addr), .read(read), .bin_out_imag(out_imag), .bin_out_real(out_real));
       

endmodule // test
