`default_nettype none
module test;

  reg reset = 0;

  initial begin
     $dumpfile("test.vcd");
     $dumpvars(0,test);
     # 200
     $finish;
  end

  // clock
  reg clk = 0;
  always #1 clk = !clk;

  agu dut(.clk (clk)); 

endmodule // test
