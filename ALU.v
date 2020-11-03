`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/17/2020 12:29:50 AM
// Design Name: 
// Module Name: ALU
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


module ALU(
    input [31:0] a,  
    input [31:0] b, 
    input [3:0] alu_control,
    output zero, 
    output reg [31:0] alu_result);  
    
 always @(*)
 begin   
      case(alu_control)  
      4'b0000: alu_result = a & b; // and  
      4'b0001: alu_result = a | b; // or  
      4'b0010: alu_result = a + b; // add  
      4'b0110: alu_result = a - b; // sub  
      
      4'b1100: alu_result = ~(a | b); //nor
      4'b0111: alu_result = (a < b) ? 1'b1 : 1'b0; //slt (set less than)
      4'b1000: alu_result = a << b[10:6]; //sll (shift left logical)
      4'b1001: alu_result = a >> b[10:6]; //srl (shift right logical)
      4'b1010: 
        alu_result = $signed(a) >>> b[10:6];
      4'b0100: alu_result = a ^ b; //xor 
      4'b0101: alu_result = a * b; //mult
      4'b1011: alu_result = a / b; //div
      
      default: alu_result = a + b; // add  
      endcase  
      
      //displays info about the operation being performed at a certain time
      /*case(alu_control)  
      4'b0000: $display("AND OPERATION AT TIME %0t", $time); // and  
      4'b0001: $display("OR OPERATION AT TIME %0t", $time); // or  
      4'b0010: $display("ADD OPERATION AT TIME %0t", $time); // add  
      4'b0110: $display("SUB OPERATION AT TIME %0t", $time); // sub  
      
      4'b1100: $display("NOR OPERATION AT TIME %0t", $time); //nor
      4'b0111: $display("SLT OPERATION AT TIME %0t", $time); //slt (set less than)
      4'b1000: $display("SLL OPERATION AT TIME %0t", $time); //sll (shift left logical)
      4'b1001: $display("SRL OPERATION AT TIME %0t", $time); //srl (shift right logical)
      4'b1010: $display("SRA OPERATION AT TIME %0t", $time); //sra (shift right arithmetic)
      4'b0100: $display("XOR OPERATION AT TIME %0t", $time); //xor 
      4'b0101: $display("MULT OPERATION AT TIME %0t", $time); //mult
      4'b1011: $display("DIV OPERATION AT TIME %0t", $time); //div
      
      default: $display("OPERATION %b AT TIME %0t", alu_result, $time); // add  
      endcase
      $display("VALUE OF A IS $b",a);
      $display("VALUE OF B IS $b",b);
      $display("THE RESULT IS $b",alu_result);*/
 end  
 assign zero = (alu_result==32'd0) ? 1'b1: 1'b0;
endmodule
