// ================== FRF (rename table) ==================
module frf #(parameter ARCH=32, PHYS=64, AW=4, PW=5)(
  input  logic                 clk, rst,
  // read current mappings
  input  logic [AW-1:0]        rs1, rs2, rd_q,
  output logic [PW-1:0]        prs1, prs2, prd_old,
  // speculative update
  input  logic                 upd_en,
  input  logic [AW-1:0]        rd,
  input  logic [PW-1:0]        prd_new,
  // recovery: full restore from checkpoint (one-port)
  input  logic                 restore_en,
  input  logic [PW-1:0]        restore_tab [ARCH]
);
  logic [PW-1:0] fut [ARCH-1:0];
  assign prs1    = fut[rs1];
  assign prs2    = fut[rs2];
  assign prd_old = fut[rd_q];

  integer i;
  always_ff @(posedge clk) begin
    if (rst) begin
      for (i=0;i<ARCH;i++) fut[i] <= i[PW-1:0];
    end else begin
      if (restore_en) begin
        for (i=0;i<ARCH;i++) fut[i] <= restore_tab[i];
      end else if (upd_en) begin
        fut[rd] <= prd_new;
      end
    end
  end
endmodule
