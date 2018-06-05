`default_nettype none
module twiddle_rom 
#(
    parameter FILE_REAL = "hdl/twiddle_real.list",
    parameter FILE_IMAJ = "hdl/twiddle_imag.list",
    parameter addr_width = 4,
    parameter data_width = 16
)
(
    input wire                  clk,
    input wire [addr_width-1:0] addr,
    output reg [data_width-1:0] dout_real,
    output reg [data_width-1:0] dout_imaj
);

reg [data_width-1:0] rom_real [(1 << addr_width)-1:0];
reg [data_width-1:0] rom_imaj [(1 << addr_width)-1:0];

initial begin
  if (FILE_REAL) $readmemh(FILE_REAL, rom_real);
  if (FILE_IMAJ) $readmemh(FILE_IMAJ, rom_imaj);
end

always @(posedge clk)
begin
    dout_real = rom_real[addr];
    dout_imaj = rom_imaj[addr];
end

endmodule

