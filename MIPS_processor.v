`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:49:20 1/20/2017 
// Design Name: 
// Module Name:    MIPS_processor 
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
// Behavioral model of MIPS - pipelined implementation

module CPU (clock,PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD);

  input clock;
  output [31:0] PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD;


// Pipeline 

   reg MEMWB_RegWrite;
   reg [4:0]	MEMWB_rd;
	reg EXMEM_Branch,EXMEM_Zero;
	reg [31:0] EXMEM_Target;

// Instruction Fetch (IF) 
   wire [31:0] PCplus4, NextPC;
   reg [31:0] PC, IMemory[0:1023], IFID_IR, IFID_PCplus4;
   ALU fetch(4'b0010,PC,4,PCplus4,Unused1);
   assign NextPC = (EXMEM_Branch && EXMEM_Zero) ? EXMEM_Target: PCplus4;

// ID
   wire [7:0] Control;
   reg IDEX_RegWrite,IDEX_MemtoReg,
       IDEX_Branch,  IDEX_MemWrite,
       IDEX_ALUSrc,  IDEX_RegDst;
   reg [1:0]  IDEX_ALUOp;
   wire [31:0] RD1,RD2,SignExtend, WD;
   reg [31:0] IDEX_PCplus4,IDEX_RD1,IDEX_RD2,IDEX_SignExt,IDEXE_IR;
   reg [31:0] IDEX_IR; // For monitoring the pipeline
   reg [4:0]  IDEX_rt,IDEX_rd;
   register_file  rf(IFID_IR[25:21],IFID_IR[20:16],MEMWB_rd,WD,MEMWB_RegWrite,RD1,RD2,clock);
   main_control MainCtr(IFID_IR[31:26],Control); 
   assign SignExtend = {{16{IFID_IR[15]}},IFID_IR[15:0]}; 
  
// EXE
   reg EXMEM_RegWrite,EXMEM_MemtoReg,EXMEM_MemWrite;
   wire [31:0] Target;
   reg [31:0] EXMEM_ALUOut,EXMEM_RD2;
   reg [31:0] EXMEM_IR; // For monitoring the pipeline
   reg [4:0] EXMEM_rd;
   wire [31:0] B,ALUOut;
   wire [2:0] ALUctl;
   wire [4:0] WR;
   ALU branch(4'b0010,IDEX_SignExt<<2,IDEX_PCplus4,Target,Unused2);
   ALU EX(ALUctl, IDEX_RD1, B, ALUOut, Zero);
   alu_control ALU_Ctrl(IDEX_ALUOp, IDEX_SignExt[5:0], ALUctl); // ALU control unit
   assign B  = (IDEX_ALUSrc) ? IDEX_SignExt: IDEX_RD2;        // ALUSrc Mux 
   assign WR = (IDEX_RegDst) ? IDEX_rd: IDEX_rt;              // RegDst Mux

// MEM
   reg MEMWB_MemtoReg;
   reg [31:0] DMemory[0:1023],MEMWB_MemOut,MEMWB_ALUOut;
   reg [31:0] MEMWB_IR; // For monitoring the pipeline
   wire [31:0] MemOut;
   assign MemOut = DMemory[EXMEM_ALUOut>>2];
   always @(posedge clock)	if (EXMEM_MemWrite) DMemory[EXMEM_ALUOut>>2] <= EXMEM_RD2;
  
// WB
   assign WD = (MEMWB_MemtoReg) ? MEMWB_MemOut: MEMWB_ALUOut; // MemtoReg Mux


   initial begin
    PC = 0;
// Initialize pipeline registers
    IDEX_RegWrite=0;IDEX_MemtoReg=0;IDEX_Branch=0;IDEX_MemWrite=0;IDEX_ALUSrc=0;IDEX_RegDst=0;IDEX_ALUOp=0;
    IFID_IR=0;
    EXMEM_RegWrite=0;EXMEM_MemtoReg=0;EXMEM_Branch=0;EXMEM_MemWrite=0;
    EXMEM_Target=0;
    MEMWB_RegWrite=0;MEMWB_MemtoReg=0;
   end

// Running the pipeline

   always@(negedge clock) 
	begin 

// IF
    PC <= NextPC;
    IFID_PCplus4 <= PCplus4;
    IFID_IR <= IMemory[PC>>2];

// ID
    IDEX_IR <= IFID_IR;                      // For monitoring the pipeline
    {IDEX_RegDst,IDEX_ALUSrc,IDEX_MemtoReg,IDEX_RegWrite,IDEX_MemWrite,IDEX_Branch,IDEX_ALUOp} <= Control;   
    IDEX_PCplus4 <= IFID_PCplus4;
    IDEX_RD1 <= RD1; 
    IDEX_RD2 <= RD2;
    IDEX_SignExt <= SignExtend;
    IDEX_rt <= IFID_IR[20:16];
    IDEX_rd <= IFID_IR[15:11];

// EXE
    EXMEM_IR <= IDEX_IR; // For monitoring the pipeline
    EXMEM_RegWrite <= IDEX_RegWrite;
    EXMEM_MemtoReg <= IDEX_MemtoReg;
    EXMEM_Branch   <= IDEX_Branch;
    EXMEM_MemWrite <= IDEX_MemWrite;
    EXMEM_Target <= Target;
    EXMEM_Zero <= Zero;
    EXMEM_ALUOut <= ALUOut;
    EXMEM_RD2 <= IDEX_RD2;
    EXMEM_rd <= WR;

// MEM
    MEMWB_IR <= EXMEM_IR; // For monitoring the pipeline
    MEMWB_RegWrite <= EXMEM_RegWrite;
    MEMWB_MemtoReg <= EXMEM_MemtoReg;
    MEMWB_MemOut <= MemOut;
    MEMWB_ALUOut <= EXMEM_ALUOut;
    MEMWB_rd <= EXMEM_rd;

// WB
// Register write happens on neg edge of the clock (if MEMWB_RegWrite is asserted)

  end

endmodule

