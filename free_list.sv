module free_list (
    input clk, rst,
    input push,
    input pop,
    input logic [6:0] push_rd,
    output logic pop_ok,
    output logic [6:0]  phy_rd
);

    logic [6:0] list [63:0];
    logic [6:0] head, tail, cnt;
    
    assign pop_ok = (cnt!=0);
    assign phy_rd = list[head];
    
    integer i;
    always_ff @(posedge clk) begin
        if(rst) begin
            head <= 0;
            tail <= 0;
            cnt <= 6'b111111;
            for(i=0;i<64;i++) begin
                list[i] <= 31+i;
            end
        end
        else begin
            if(pop && pop_ok) begin
                head <= (head+1 > 6'b111111)?0:head+1;
                cnt <= cnt - 1;
            end
            if(push) begin
                list[tail] <= push_rd;
                tail <= (tail+1 > 6'b111111)?0:tail+1;
                cnt <= cnt + 1;
            end            
        end
    end
            
endmodule
        
             

    
