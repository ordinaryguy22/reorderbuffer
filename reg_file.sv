module reg_file #(
    parameter DEPTH = 32,
    parameter WIDTH = 32
) (
    input  logic clk, 
    input  logic reset_n, 
    //decode 
    input  logic decode,
    input  logic tag_rd,

    input  logic [4:0] raddr1, 
    input  logic [4:0] raddr2, 
    input  logic [4:0] rdaddr,
    
    input logic reg_write,
    
    output logic [4:0] valid_rs1,
    output logic [5:0] tag_rs1,
    output logic [4:0] valid_rs2,
    output logic [5:0] tag_rs2
    
    
//    input  logic [4:0] waddr, 
//    input  logic [31:0] wdata,
//    output logic [31:0] rdata1,
//    output logic [31:0] rdata2
);
      typedef struct packed {
        logic v;
        logic [5:0] tag;
        } arch_reg;
        
    arch_reg reg_file [1:DEPTH-1]; // Exclude x0 (index 0)


    int i;

    always @(posedge clk or negedge reset_n) begin 
        if (!reset_n) begin 
            for (i = 1; i < DEPTH; i = i + 1) begin
                reg_file[i].v <= 1;
                reg_file[i].tag <= 0;
            end
        end
        
        else if(decode) begin
            reg_file[rdaddr].v <= 0; 
            reg_file[rdaddr].tag <= tag_rd;
        end
        
        else if(reg_write)begin
            reg_file[rdaddr].v <= 1;
        end
         

    end

      assign valid_rs1 = reg_file[raddr1].v;
      assign tag_rs1 = reg_file[raddr1].tag;
      
      assign valid_rs2 = reg_file[raddr2].v;
      assign tag_rs2 = reg_file[raddr2].tag; 


`ifdef VCS_SIM
    logic [31:0] x1,x2,x3,x4,x5,x6,x7,x8,x9,x10,x11,x12,x13,x14,x15,x16,x17;
    logic [31:0] x18,x19,x20,x21,x22,x23,x24,x25,x26,x27,x28,x29,x30,x31;
    assign x1  = reg_file[1];
    assign x2  = reg_file[2];
    assign x3  = reg_file[3];
    assign x4  = reg_file[4];
    assign x5  = reg_file[5];
    assign x6  = reg_file[6];
    assign x7  = reg_file[7];
    assign x8  = reg_file[8];
    assign x9  = reg_file[9];
    assign x10 = reg_file[10];
    assign x11 = reg_file[11];
    assign x12 = reg_file[12];
    assign x13 = reg_file[13];
    assign x14 = reg_file[14];
    assign x15 = reg_file[15];
    assign x16 = reg_file[16];
    assign x17 = reg_file[17];
    assign x18 = reg_file[18];
    assign x19 = reg_file[19];
    assign x20 = reg_file[20];
    assign x21 = reg_file[21];
    assign x22 = reg_file[22];
    assign x23 = reg_file[23];
    assign x24 = reg_file[24];
    assign x25 = reg_file[25];
    assign x26 = reg_file[26];
    assign x27 = reg_file[27];
    assign x28 = reg_file[28];
    assign x29 = reg_file[29];
    assign x30 = reg_file[30];
    assign x31 = reg_file[31];
`endif


endmodule
