`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:57:31 1/19/2017 
// Design Name: 
// Module Name:    ALU 
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
module ALU(alu_ctl,A,B,alu_out,Zero);

  input [3:0] alu_ctl;
  input [31:0] A,B;
  output reg [31:0] alu_out;
  output Zero;

  assign Zero = (alu_out==0);      // Zero is true if alu_out is 0
  always @(alu_ctl, A, B)          // re-evaluate if these change
  begin
    case (alu_ctl)
      4'b0000: alu_out <= A & B;         // AND Operation
      4'b0001: alu_out <= A | B;         // OR  Operation
      4'b0010: alu_out <= A + B;         // Addition
      4'b0110: alu_out <= A - B;         // Subtraction
      4'b0111: alu_out <= (A < B) ? 1:0;    // Comparator
		4'b1100: alu_out <= ~(A|B);        //NOR Operation 
      default: alu_out <= 0;              //default to 0
	 endcase
  end
   
endmodule
