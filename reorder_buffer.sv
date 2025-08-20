module rob(
    input clk,rst,
    input decode,
    input logic [4:0] rdaddr,
    input logic [5:0] pr,
    input logic [63:0] current_pc,
    input logic exception,
    
    input logic wb_en,
    
    input logic result_rd_tag,
    input logic writeback,
    
    output logic [4:0] rd_rob,
    
    //reorder write: where the data from execution will be written into the rob register until it is committed
    output logic [5:0] rob_pr, // the physical register where rob entry is aligned, given by RAT
    output logic reorder, 
    
    //writeback
    output logic wb_ready,
    output logic [4:0] rd_id,
    output logic [4:0] rob_pr
 
    );
    
    typedef struct packed{
    logic v;
    logic [4:0] rd_id;
    logic rd_v;
    logic [5:0] pr;
    logic [63:0] pc;
    logic exception;
    logic [4:0] tag;
    } rob_entry_t;
    
    rob_entry_t ROB[32];
    logic [4:0] head,tail;
    
    integer i;
    always_ff @(posedge clk) begin
        if(rst)begin
            for(i=0;i<32;i++)begin
                ROB[i] <= '0;
                ROB[i].tag <= 32+i;
            end
            head <= 0;
            tail <= 0;
        end
        
        if(decode) begin
            ROB[tail].v <= 1;
            ROB[tail].rd_id <= rdaddr;
            ROB[tail].rd_v <= 0;
            ROB[tail].pr <= pr;
            ROB[tail].pc <= current_pc;
            ROB[tail].exception <= exception;
            tail <= tail+1;
        end
        
        if(reorder) begin
            rob_pr <= ROB[result_rd_tag].pr;
            ROB[result_rd_tag].v <= 1;
        end
                
        if(writeback && ROB[head].rd_v == 1) begin            
            wb_ready <=1;
            rd_id <= ROB[head].rd_id;
            rob_pr <= ROB[head].pr;
            ROB[head] <= '0;
            head <= head+1;
       end
        
    end
    
    
    
endmodule
