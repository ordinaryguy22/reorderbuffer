// ================== ROB ==================
module rob #(parameter ARCH=32, PHYS=64, ROBN=16,
             AW=$clog2(ARCH), PW=5, RW=4)(
  input  logic                 clk, rst,
  // allocate at tail
  input  logic                 alloc_en,
  input  logic [AW-1:0]        ard_in,
  input  logic [PW-1:0]        prd_new_in,
  input  logic [PW-1:0]        prd_old_in,
  output logic                 alloc_ok,
  output logic [RW-1:0]        rob_idx_alloc,
  // mark ready by PRD at WB
  input  logic                 wb_en,
  input  logic [PW-1:0]        wb_prd,
  // commit at head
  output logic                 commit_valid,
  output logic [AW-1:0]        commit_ard,
  output logic [PW-1:0]        commit_prd_new,
  output logic [PW-1:0]        commit_prd_old,
  input  logic                 commit_pop
);
  typedef struct packed {
    logic        v;
    logic        rdy;
    logic [AW-1:0] ard;
    logic [PW-1:0] prd_new, prd_old;
  } entry_t;

  entry_t q [ROBN-1:0];
  logic [RW-1:0] head, tail;
  logic [RW:0]   cnt;

  assign alloc_ok       = (cnt != ROBN);
  assign rob_idx_alloc  = tail;
  assign commit_valid   = (cnt!=0) && q[head].v && q[head].rdy;
  assign commit_ard     = q[head].ard;
  assign commit_prd_new = q[head].prd_new;
  assign commit_prd_old = q[head].prd_old;

  integer i;
  always_ff @(posedge clk) begin
    if (rst) begin
      for (i=0;i<ROBN;i++) q[i] <= '0;
      head<=0; tail<=0; cnt<=0;
    end else begin
      if (alloc_en && alloc_ok) begin
        q[tail].v       <= 1'b1;
        q[tail].rdy     <= 1'b0;
        q[tail].ard     <= ard_in;
        q[tail].prd_new <= prd_new_in;
        q[tail].prd_old <= prd_old_in;
        tail <= (tail+1==ROBN)?0:tail+1;
        cnt  <= cnt+1;
      end
      if (wb_en) begin
        for (i=0;i<ROBN;i++) if (q[i].v && q[i].prd_new==wb_prd) q[i].rdy <= 1'b1;
      end
      if (commit_pop && commit_valid) begin
        q[head].v <= 1'b0;
        head <= (head+1==ROBN)?0:head+1;
        cnt  <= cnt-1;
      end
    end
  end
endmodule
