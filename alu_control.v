`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:00:54 1/20/2017 
// Design Name: 
// Module Name:    alu_control 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module alu_control(alu_op,Func_Code,alu_ctl); 
  input [1:0] alu_op;
  input [5:0] Func_Code;
  output reg [3:0] alu_ctl;

  always @(alu_op,Func_Code)
  begin  
  case (alu_op)
    2'b00: alu_ctl <= 4'b0010; // add
    2'b01: alu_ctl <= 4'b0110; // subtract
    2'b10: case (Func_Code)
	     6'b100000: alu_ctl <= 4'b0010; // add
	     6'b100010: alu_ctl <= 4'b0110; // subtract
	     6'b100100: alu_ctl <= 4'b0000; // and
	     6'b100101: alu_ctl <= 4'b0001; // or
	     6'b101010: alu_ctl <= 4'b0111; // slt
	default: alu_ctl <= 15; 
  endcase
 endcase
 end
  
endmodule