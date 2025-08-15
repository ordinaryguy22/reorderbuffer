// ================== Free List (circular FIFO of phys regs) ==================
module free_list #(parameter ARCH=32, PHYS=64, PW=5)(
  input  logic           clk, rst,
  input  logic           alloc,       // pop
  output logic           alloc_ok,
  output logic [PW-1:0]  prd_alloc,
  input  logic           free_en,     // push
  input  logic [PW-1:0]  prd_free
);
  localparam int N = PHYS-ARCH;
  logic [PW-1:0] q [N-1:0];
  logic [$clog2(N):0] head, tail, cnt;

  assign alloc_ok  = (cnt!=0);
  assign prd_alloc = q[head];

  integer i;
  always_ff @(posedge clk) begin
    if (rst) begin
      for (i=0;i<N;i++) 
      begin
        q[i] <= (ARCH+i);
      end
      head<=0; tail<=0; cnt<=N;
    end else begin
      if (alloc && alloc_ok) begin head <= (head+1==N)?0:head+1; cnt<=cnt-1; end
      if (free_en) begin q[tail] <= prd_free; tail <= (tail+1==N)?0:tail+1; cnt<=cnt+1; end
    end
  end
endmodule
