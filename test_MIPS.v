// Test module

module test ();

  reg clock;
  wire [31:0] PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WriteData;

  CPU test_cpu(clock,PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD);

  always #1 clock = ~clock;
  
  initial begin
    $display ("time PC  IFID_IR  IDEX_IR  EXMEM_IR MEMWB_IR WD");
    $monitor ("%2d  %3d  %h %h %h %h %h", $time,PC,IFID_IR,IDEX_IR,EXMEM_IR,MEMWB_IR,WD);
    clock = 1;
    #56 $finish;
  end

endmodule


/* Compiling and simulation




initial begin 
// Program: swap memory cells (if needed) and compute absolute value |5-7|=2
   IMemory[0]  = 32'h8c080000;  // lw $8, 0($0)
   IMemory[1]  = 32'h8c090004;  // lw $9, 4($0)
   IMemory[2]  = 32'h00000000;  // nop
   IMemory[3]  = 32'h00000000;  // nop
   IMemory[4]  = 32'h00000000;  // nop
   IMemory[5]  = 32'h0109502a;  // slt $10, $8, $9
   IMemory[6]  = 32'h00000000;  // nop
   IMemory[7]  = 32'h00000000;  // nop
   IMemory[8]  = 32'h00000000;  // nop
   IMemory[9]  = 32'h11400005;  // beq $10, $0, IMemory[15]  
   IMemory[10] = 32'h00000000;  // nop
   IMemory[11] = 32'h00000000;  // nop
   IMemory[12] = 32'h00000000;  // nop
   IMemory[13] = 32'hac080004;  // sw $8, 4($0)
   IMemory[14] = 32'hac090000;  // sw $9, 0($0)
   IMemory[15] = 32'h00000000;  // nop
   IMemory[16] = 32'h00000000;  // nop
   IMemory[17] = 32'h00000000;  // nop
   IMemory[18] = 32'h8c080000;  // lw $8, 0($0)
   IMemory[19] = 32'h8c090004;  // lw $9, 4($0)
   IMemory[20] = 32'h00000000;  // nop
   IMemory[21] = 32'h00000000;  // nop
   IMemory[22] = 32'h00000000;  // nop
   IMemory[23] = 32'h01095022;  // sub $10, $8, $9
// Data
   DMemory [0] = 32'h5; // switch the cells and see how the simulation output changes
   DMemory [1] = 32'h7; // (beq is taken if [0]=32'h7; [1]=32'h5, not taken otherwise)
  end
C:\Markov\CCSU Stuff\Courses\Spring-10\CS385\HDL>iverilog mips-pipe.vl

C:\Markov\CCSU Stuff\Courses\Spring-10\CS385\HDL>vvp a.out

time PC  IFID_IR  IDEX_IR  EXMEM_IR MEMWB_IR WD
 0    0  00000000 xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx
 1    4  8c080000 00000000 xxxxxxxx xxxxxxxx xxxxxxxx
 3    8  8c090004 8c080000 00000000 xxxxxxxx xxxxxxxx
 5   12  00000000 8c090004 8c080000 00000000 00000000
 7   16  00000000 00000000 8c090004 8c080000 00000005
 9   20  00000000 00000000 00000000 8c090004 00000007
11   24  0109502a 00000000 00000000 00000000 00000000
13   28  00000000 0109502a 00000000 00000000 00000000
15   32  00000000 00000000 0109502a 00000000 00000000
17   36  00000000 00000000 00000000 0109502a 00000001
19   40  11400005 00000000 00000000 00000000 00000000
21   44  00000000 11400005 00000000 00000000 00000000
23   48  00000000 00000000 11400005 00000000 00000000
25   52  00000000 00000000 00000000 11400005 00000001
27   56  ac080004 00000000 00000000 00000000 00000000
29   60  ac090000 ac080004 00000000 00000000 00000000
31   64  00000000 ac090000 ac080004 00000000 00000000
33   68  00000000 00000000 ac090000 ac080004 00000004
35   72  00000000 00000000 00000000 ac090000 00000000
37   76  8c0b0000 00000000 00000000 00000000 00000000
39   80  8c0c0004 8c0b0000 00000000 00000000 00000000
41   84  00000000 8c0c0004 8c0b0000 00000000 00000000
43   88  00000000 00000000 8c0c0004 8c0b0000 00000007
45   92  00000000 00000000 00000000 8c0c0004 00000005
47   96  016c5822 00000000 00000000 00000000 00000000
49  100  xxxxxxxx 016c5822 00000000 00000000 00000000
51  104  xxxxxxxx xxxxxxxx 016c5822 00000000 00000000
53  108  xxxxxxxx xxxxxxxx xxxxxxxx 016c5822 00000002
55  112  xxxxxxxx xxxxxxxx xxxxxxxx xxxxxxxx 0000000X

*/