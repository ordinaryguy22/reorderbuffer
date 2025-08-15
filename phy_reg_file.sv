// ================== PRF ==================
module prf #(parameter XLEN=64, PHYS=64, PW=4)(
  input  logic                 clk,
  // 2R1W ports (expand as needed)
  input  logic [PW-1:0]        raddr1, raddr2,
  output logic [XLEN-1:0]      rdata1, rdata2,
  input  logic                 we,
  input  logic [PW-1:0]        waddr,
  input  logic [XLEN-1:0]      wdata
);
  logic [XLEN-1:0] phys [PHYS-1:0];
  assign rdata1 = phys[raddr1];
  assign rdata2 = phys[raddr2];
  always_ff @(posedge clk) if (we) phys[waddr] <= wdata;
endmodule
