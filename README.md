## Project Milestone 2 ##
### Group_03 members: ###
Xiao Ding
Xinran Tang
Qing Xiang (NetID:qx657)

### Modules ###
  Program Counter(pc.vhd):
    Contains 32-bit instruction address.
    Updates instruction address in Write Back stage.
    Outputs the current address for fetching an instruction in the next stage(Instruction Fetch).
    Resets to 0x01000000.
    
    Testbench(pc_tb.v): Tests reset functionality, output with two random input addresses, and output with PC write disabled.
    
  Immediate Generator(imm_gen.vhd):
    Generates a sign-extended immediate value according to the 32-bit input instruction.
    Outputs the generated value to be one of the choices of the second operand of ALU.
    Outputs 32-bit 0 by default(immediate value not required).
  
    Testbench(imm_gen_tb.v): Tests output with random positive and negative input instructions that cover all possible types.
  
  Control Unit(control.vhd):
    Generates control signals for other essential components according to the opcode.
    Contains a finite state machine that enables multi-cycle execution.
    Sets and Outputs signals to components by stages: Instruction Fetch(IFE), Instruction Decode and Execute(EXE), Memory Access(MEM), Write Back(WB), and Halt(HLT).
  
    Testbench(control_tb.v): Reads from a file all types of opcodes and tests the output signals in each stage.
    Also tests reset functionality and continuinity between two opcodes.
    

  Register File(Register_File.vhd):
    
  
    Testbench(Register_File_tb.v):
    
  Arithmetic Logic Unit(ALU.vhd):
    
  
    Testbench(ALU_tb.v):
    
  ALU Control(ALU_Control.vhd):
    
  
    Testbench(ALU_Control_tb.v):
    
  Instruction Memory(imem.vhd):
    
  
    Testbench(imem_tb.v):
 
  Data Memory(dmem.vhd):
    
  
    Testbench(dmem_tb.v):
 
 
 
 
