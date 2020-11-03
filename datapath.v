`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/16/2020 02:31:52 PM
// Design Name: 
// Module Name: datapath
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module datapath(
    input clk, reset, 
    input reg_dst, reg_write,
    input alu_src, pc_src, //pc_src is passed in as branch (see mips_32.v)
    input mem_read, mem_write,
    input mem_to_reg, 
    input [3:0] ALU_Control, 
    input branch, jump,
    output [31:0] datapath_result,
    output [5:0] inst_31_26, 
    output [5:0] inst_5_0
    );
    
    //necessary wires
    reg [9:0] pc; 
    wire [9:0] pc_plus4;// = 6'b000000;
    wire [31:0] instr;
    wire [4:0] write_reg_addr;
    wire [31:0] write_back_data;
    wire [31:0] reg1, reg2;
    wire [31:0] imm_value;
    wire [31:0] alu_in2;
    wire zero;
    wire jump;
    wire [31:0] alu_result;
    wire [31:0] mem_read_data;
    
    wire [31:0] beq_addr;
    wire [31:0] jump_addr;
    wire [31:0] beq_interim;
    
    //add 4 to pc counter every cycle OR reset if reset option toggled on
    always @(posedge clk or posedge reset)  
     begin   
          if(reset)   
               pc <= 10'b0000000000;  
          else  
               pc <= pc_plus4; 
               //$display("Addr: is %b", pc);
     end  
 
    //add 4 every time
    assign beq_addr = pc + 10'b0000000100 + {instr[7:0], 2'b00} ; //branch addr
    assign jump_addr = {pc[31:28] + 4'b0100, {instr[25:0],2'b00}}; //jump addr
    //assign pc_plus4 = (pc_src == 1'b1 & zero == 1'b1) ? beq_addr : pc + 10'b0000000100; 
    assign pc_plus4 = (jump == 1'b1) ? jump_addr : ( (branch == 1'b1 & zero == 1'b1) ? beq_addr : pc + 10'b0000000100 ); 
    //assign PC_Src = zero & pc_src; //if zero AND pc_src(branch actually passed in branch, see mips_32.v) 
        
    /*
    pc is fed into the instruction memory to begin processing the instructions
    */
    instruction_mem inst_mem (
        .read_addr(pc),
        .data(instr));
        
    assign inst_31_26 = instr[31:26];
    assign inst_5_0 = instr[5:0];
    
    mux2 #(.mux_width(5)) reg_mux 
    (   .a(instr[20:16]),
        .b(instr[15:11]),
        .sel(reg_dst),
        .y(write_reg_addr));
        
    register_file reg_file (
        .clk(clk),  
        .reset(reset),  
        .reg_write_en(reg_write),  
        .reg_write_dest(write_reg_addr),  
        .reg_write_data(write_back_data),  
        .reg_read_addr_1(instr[25:21]), 
        .reg_read_addr_2(instr[20:16]), 
        .reg_read_data_1(reg1),
        .reg_read_data_2(reg2));  
        
    sign_extend sign_ex_inst (
        .sign_ex_in(instr[15:0]),
        .sign_ex_out(imm_value));
        
    mux2 #(.mux_width(32)) alu_mux 
    (   .a(reg2),
        .b(imm_value),
        .sel(alu_src),
        .y(alu_in2));
        
    ALU alu_inst (
        .a(reg1),
        .b(alu_in2),
        .alu_control(ALU_Control),
        .zero(zero),
        .alu_result(alu_result));
        
    data_memory data_mem (
        .clk(clk),
        .mem_access_addr(alu_result),
        .mem_write_data(reg2),
        .mem_write_en(mem_write),
        .mem_read_en(mem_read),
        .mem_read_data(mem_read_data));
        
     mux2 #(.mux_width(32)) writeback_mux 
    (   .a(alu_result),
        .b(mem_read_data),
        .sel(mem_to_reg),
        .y(write_back_data));  
        
    /*mux2 #(.mux_width(32)) pc_src_mux //decides whether to take branch addr
    (
        .a(pc_plus4),
        .b(beq_addr),
        .sel(pc_src && zero),
        .y(pc_plus4)
    ); */
        
    assign datapath_result = write_back_data;
endmodule
