// ================== ARF ==================
module arf #(parameter XLEN=64, ARCH=32, AW=4)(
  input  logic                 clk,
  input  logic                 we,
  input  logic [AW-1:0]        waddr,
  input  logic [XLEN-1:0]      wdata
);
  logic [XLEN-1:0] mem [ARCH-1:0];
  always_ff @(posedge clk) if (we) mem[waddr] <= wdata;
endmodule
