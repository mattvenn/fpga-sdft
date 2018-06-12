`default_nettype none
`include "tests/top_tb_header.vh"
module test;

    localparam freq_bins = 16;
    localparam bin_addr_w = $clog2(freq_bins);
    localparam data_w = 8;
    localparam addr_w = 8;
    localparam num_tests = 2 ** addr_w;
    integer i;

    wire [data_w-1:0] d_out;
    reg [data_w-1:0] d_in = 0;
    reg w_en = 0;
    reg r_en = 0;
    reg [addr_w-1:0] r_addr = 0;
    reg [addr_w-1:0] w_addr = 0;


    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0,test);
        for (i = 0 ; i < freq_bins ; i = i + 1) begin
            $dumpvars(1, top_0.freq_bram_0.ram[i]);
        end
        wait(top_0.y_px == 1);
        wait(top_0.y_px == 40);
        # 200
        $finish;
    end

    // clock
    reg clk = 0;
    always #1 clk = !clk;

    top top_0(.clk(clk));

endmodule

