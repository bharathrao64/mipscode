`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:55:42 1/16/2017 
// Design Name: 
// Module Name:    register_file 
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
module register_file(Read1,Read2,WriteReg,WriteData,RegWrite,Data1,Data2,clock);

  input [5:0] Read1,Read2,WriteReg;
  input [31:0] WriteData;
  input RegWrite,clock;
  output [31:0] Data1,Data2;

  reg [31:0] Regs[0:31];

  assign Data1 = Regs[Read1];
  assign Data2 = Regs[Read2];

  always @(posedge clock)
    if (RegWrite==1)
		begin
			Regs[WriteReg] <= WriteData;
		end
	 else
	 begin
		Regs[WriteReg] <= Regs[WriteReg];
	 end

endmodule
