## Project Milestone 2 ##
### Group_03 members: ###
Xiao Ding (NetID:xd2076),
Xinran Tang (NetID:xt2191),
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
The implemented instruction memory is word address indexes, and it has the size of 2KBytes, the addresses begin at 0x01000000. The input addresses are byte address indexed, by translating the byte address indexed input address into word address indexed the instruction at the word address indexed memory will be catched. Upon reset, the PC will be set to 0x01000000. 

    Testbench(imem_tb.v): Firstly, the rest function is tested by setting the t_rst to 1. Then, the cases when t_rst equals to 0 are tested. The tested program is stored in rom_words, when input addresses are 0x01000000, 0x01000004, 0x01000008, and 0x0100000c, the output instruction are (addi x1, x0, 1), (addi x2, x0, 2), (add x1, x1, x2), and (j loop) repectively.

  Data Memory(dmem.vhd):
The implemented data memory is word address indexes, and it has the size of 4KBytes, the addresses begin at 0x80000000. The write function is built by using 4 interleaved sets of 8-bit (one byte) wide memories. The special read-only memory-mapped values at addresses 0x00100000, 0x00100004 and 0x00100008 are 0x11987251, 0x18790475 and 0x10257233 respectively, which are N numbers of our group members. 

    Testbench(dmem_tb.v): Firstly, the rest function is tested by setting the t_rst to 1. Then, the cases when t_rst equals to 0 are tested. When the read function is enable, three special read-only memory-mapped values at addresses 0x00100000, 0x00100004 and 0x00100008 are tested by having the correct N numbers as output data. When the write function is enable, 4 bit of write enable are tested, by checking whether the corresponding bits are written at the correct bit position.

 

 

