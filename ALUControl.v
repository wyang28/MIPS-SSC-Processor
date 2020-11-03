`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2020 04:24:03 AM
// Design Name: 
// Module Name: ALUControl
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


module ALUControl(
    input [1:0] ALUOp, 
    input [5:0] Function,
    output reg[3:0] ALU_Control);  

wire [7:0] ALUControlIn;  
 assign ALUControlIn = {ALUOp,Function};  
 always @(ALUControlIn)  
 
 //* and andi?
 casex (ALUControlIn)               //       ALUOp + Function
  8'b1x100100: ALU_Control=4'b0000; //and*,  1x      100100   
  8'b10100101: ALU_Control=4'b0001; //or,    10      100010 
  8'b00xxxxxx: ALU_Control=4'b0010; //addi,  00      xxxxxx
  8'b11xxxxxx: ALU_Control=4'b0000; //andi,  11      xxxxxx
  8'b10100000: ALU_Control=4'b0010; //add,   10      100000
  8'b10100010: ALU_Control=4'b0110; //sub,   10      100010   
  8'b10100111: ALU_Control=4'b1100; //nor,   10      100111
  8'b10101010: ALU_Control=4'b0111; //slt,   10      101010
  8'b10000000: ALU_Control=4'b1000; //sll,   10      000000
  8'b10000010: ALU_Control=4'b1001; //srl,   10      000010
  8'b10000011: ALU_Control=4'b1010; //sra,   10      100011
  8'b10100110: ALU_Control=4'b0100; //xor,   10      100110
  8'b10011000: ALU_Control=4'b0101; //mult,  10      011000
  8'b10011010: ALU_Control=4'b1011; //div,   10      011010
  8'b01xxxxxx: ALU_Control=4'b0110; //beq,   01,     xxxxxx
  default: ALU_Control=4'b0000;  
  endcase  
 endmodule  



