`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:59:54 1/19/2017 
// Design Name: 
// Module Name:    main_control 
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
module main_control(Op,control); 

  input [5:0] Op;
  output reg [7:0] control;

  always @(Op) 
  begin
	case(Op)
    6'b000000: control <= 8'b10010010;        // R-type Instruction
    6'b100011: control <= 8'b01110000;        // Load Instruction
    6'b101011: control <= 8'b01001000;        // Store Instruction  
    6'b000100: control <= 8'b00000101;        // Branch Instruction    
	endcase
  end

endmodule
