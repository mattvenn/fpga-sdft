`default_nettype none
module test;

    reg reset = 0;
    reg signed [7:0] sample = 0;

    integer i;
    initial begin
        $dumpfile("test.vcd");
        $dumpvars(0,test);
        b_real = 2;
        b_imag = -1;
        a_real = 3;
        a_imag = 1;
        # 4
        b_real = -2;
        b_imag = -2;
        a_real = -3;
        a_imag = -3;
        # 4
        b_real = 2;
        b_imag = 4;
        a_real = 3;
        a_imag = 4;
        # 4

        $finish;
    end

    // clock
    reg clk = 0;
    always #1 clk = !clk;

    reg signed [7:0] o_real = 0;
    reg signed [7:0] o_imag = 0;
    reg signed [7:0] b_real;
    reg signed [7:0] b_imag;
    reg signed [7:0] a_real;
    reg signed [7:0] a_imag;

    always @(posedge clk) begin
        o_real <= a_real * b_real - a_imag * b_imag;
        o_imag <= a_real * b_imag + a_imag * b_real;
    end

endmodule // test

