# Project Milestone 3 #

### Group_03 members: ###

Xiao Ding (NetID:xd2076),
Xinran Tang (NetID:xt2191),
Qing Xiang (NetID:qx657)



## Top Module - Processor ##
processor.vhd is the module that interconnects all components.
Components include:
  pc.vhd  imem.vhd  dmem.vhd  control.vhd rf.vhd  alucontrol.vhd  immgen.vhd  alu.vhd
For implementing on a FPGA, board.v is added as the top module that includes the processor module.
The project also includes reg_32_pkg.vhd, a package that defines an array type and is used in multiple modules.
Some important features:
Asynchronous active-high reset.
The processor has five stages, each of which takes one clock cycle to execute.
Memory access stage is skipped when not needed.
The processor handles imem(read) and dmem(read/write) out-of-bound situation by halting the program.

## Testbench/Simulation (VHDL)
Testbenches include
  tb_main2_processor: tests instructions without branch or jump.
  tb_main7_processor: tests mainly branch and jump instructions.
  tb_bubble2: tests implementation of bubble-sort function.
  tb_special: tests special data memory locations: N-numbers and LEDs.
For each testbench, the program outputs the register file as an array,
so that we can check if every register contains the desired value.
Test instructions are loaded to the instruction memory by reading memory files.
Target memory files are changed for different testbenches.

### single instruction tests

#### main2.mem
```
ADDI x1, x2, -255
SLTI x2, x2, -5
SLTIU x3, x2, -5
XORI x4, x1, 1
ORI x5, x1, 3
ANDI x6, x1, 3
SLLI x7, x1, 3
SRLI x8, x1, 3
SRAI x9, x1, 3
ADD x10, x1, x3
SUB x11, x1, x3
SLL x12, x1, x3
SLT x13, x1, x3
SLTU x14, x1, x3
XOR x15, x1, x3
SRL x16, x1, x3
SRA x17, x1, x3
OR x18, x1, x3
AND x19, x1, x3
LUI x20, -255
AUIPC x21, -255
ADDI x22, x0, 16
LUI x23, 524288
SB x5, 4(x23)
SH x5, 8(x23)
SW x5, 12(x23)
LB x24, 4(x23) 
LH x25, 8(x23)
LW x26, 12(x23)
LBU x27, 12(x23)
LHU x28, 12(x23)
```

#### main7.mem
```
LUI x30, 4096          
JAL x1, 8              
ECALL                  
JALR x2, x30, 20       
EBREAK                 
JAL x3, 8              
ADDI x4, x4, 255       
ADDI x7, x7, 255       
FENCE
BEQ x7, x8, 8          
ADDI x8, x8, 255       
BEQ x7, x8, 8          
ADDI x9, x9, 255       
BNE x7, x8, 8         
ADDI x10, x10, 255   
BNE x7, x9, 8          
ADDI x11, x11, 255     
BLT x7, x8, 8         
ADDI x12, x12, 255     
BLT x7, x9, 8          
ADDI x13, x13, 255     
BLT x9, x7, 8          
ADDI x14, x14, 255     
BGE x7, x8, 8         
ADDI x15, x15, 255    
BGE x7, x9, 8         
ADDI x16, x16, 255   
BGE x9, x7, 8         
ADDI x17, x17, 255    
ADDI x18, x18, -3    
BLTU x7, x18, 8     
ADDI x19, x19, 255   
BLTU x7, x8, 8       
ADDI x20, x20, 255     
BLTU x18, x7, 8     
ADDI x21, x21, 255  
BGEU x7, x18, 8      
ADDI x22, x22, 255    
BGEU x7, x8, 8      
ADDI x23, x23, 255     
BGEU x18, x7, 8     
ADDI x24, x24, 255   
```

#### special_addr.mem
```
lui x30, 256
addi x31, x31, 255
sw x31, 20(x30)
lw x1, 0(x30)
lw x2, 4(x30)
lw x3, 8(x30)
lw x4, 20(x30)
sw x1, 0(x30)
addi x5, x5, 255
```

### Complex Functions

Both complex functions are written in C and translated to RICS V assembly language and then further translated to machine code. The original C programs are adopted from online sources (please see references at the end) and then modified to fit our testing purpose.

#### RC5
Skeys are randomly generated and provided.
It does 12 rounds of encryption.
Input plaintext(pt) is in the form of an array containing two words(unsigned long type, 32-bit).
pt[0] = 123456; pt[1] = 777888
Output cyphertext(ct) is in the same form as the input.
ct[0] = 1679031343; ct[1] = 438249255
The cyphertext is produced by the C code and tested against the output of our RC5 implementation.
Our RC5 implementation successfully produces the desired cyphertext after encryption
and gives back the input plaintext after decryption.

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define W 16 // word size, in bits
#define R 5 // number of rounds
#define B 32 // number of bytes in key
#define L (B/4) // number of words in key

typedef unsigned long word;

int main() {
  word s[2*(R+1)], pt[2], ct[2];
  // initialize s[] with key
  s[0]=123;
  s[1]=456;
  s[2]=789;
  s[3]=234;
  s[4]=9876;
  s[5]=7777;
  s[6]=3333;
  s[7]=9987;
  s[8]=1367;
  s[9]=3785;
  s[10]=9743;
  s[11]=432;

  pt[0]=123456;
  pt[1]=777888;

//   printf("pt[0] before: %lu\n", pt[0]);
//   printf("pt[0] before: %lu\n", pt[1]);

  // encrypt
  word A_array_en = pt[0] + s[0];
  word B_array_en = pt[1] + s[1];
  for (int i = 1; i <= R; i++) {
    A_array_en = (((A_array_en ^ B_array_en) << B_array_en)|((A_array_en ^ B_array_en) >> (32 - B_array_en))) + s[2*i];
    B_array_en = (((B_array_en ^ A_array_en) << A_array_en)|((B_array_en ^ A_array_en) >> (32 - A_array_en))) + s[2*i+1];
  }
  ct[0] = A_array_en; ct[1] = B_array_en;
  //printf("ct[0]: %lu\n", ct[0]);
  //printf("ct[1]: %lu\n", ct[1]);

  // decrypt
  word B_array_de = ct[1];
  word A_array_de = ct[0];
  for (int j = R; j > 0; j--) {
    B_array_de = (((B_array_de - s[2*j+1]) >> A_array_de)|((B_array_de - s[2*j+1]) << (32 - A_array_de))) ^ A_array_de;
    A_array_de = (((A_array_de - s[2*j]) >> B_array_de)|((A_array_de - s[2*j]) << (32 - B_array_de))) ^ B_array_de;
  }
  pt[1] = B_array_de - s[1]; pt[0] = A_array_de - s[0];

//   printf("pt[0] after: %lu\n", pt[0]);
//   printf("pt[1] after: %lu\n", pt[1]);

  return 0;
}
```
##### corresponding RISC-V Code
RC5_final3.mem
```
addi x2 x2 -112
sw x1 108(x2)
sw x8 104(x2)
addi x8 x2 112
addi x10 x0 0
sw x10 -12(x8)
addi x10 x0 123
sw x10 -60(x8)
addi x10 x0 456
sw x10 -56(x8)
addi x10 x0 789
sw x10 -52(x8)
addi x10 x0 234
sw x10 -48(x8)
lui x10 2
addi x11 x10 1684
sw x11 -44(x8)
addi x11 x10 -415
sw x11 -40(x8)
lui x11 1
addi x12 x11 -763
sw x12 -36(x8)
addi x12 x10 1795
sw x12 -32(x8)
addi x12 x0 1367
sw x12 -28(x8)
addi x11 x11 -311
sw x11 -24(x8)
addi x10 x10 1551
sw x10 -20(x8)
addi x10 x0 432
sw x10 -16(x8)
lui x10 30
addi x10 x10 576
sw x10 -68(x8)
lui x10 190
addi x10 x10 -352
sw x10 -64(x8)
lw x10 -68(x8)
lw x11 -60(x8)
add x10 x10 x11
sw x10 -80(x8)
lw x10 -64(x8)
lw x11 -56(x8)
add x10 x10 x11
sw x10 -84(x8)
addi x10 x0 1
sw x10 -88(x8)
jal x0 4
lw x11 -88(x8)
addi x10 x0 5
blt x10 x11 136
jal x0 4
lw x10 -80(x8)
lw x12 -84(x8)
xor x11 x10 x12
sll x10 x11 x12
sub x12 x0 x12
srl x11 x11 x12
or x10 x10 x11
lw x11 -88(x8)
slli x11 x11 3
addi x12 x8 -60
add x11 x11 x12
lw x11 0(x11)
add x10 x10 x11
sw x10 -80(x8)
lw x10 -84(x8)
lw x13 -80(x8)
xor x11 x10 x13
sll x10 x11 x13
sub x13 x0 x13
srl x11 x11 x13
or x10 x10 x11
lw x11 -88(x8)
slli x11 x11 3
add x11 x11 x12
lw x11 4(x11)
add x10 x10 x11
sw x10 -84(x8)
jal x0 4
lw x10 -88(x8)
addi x10 x10 1
sw x10 -88(x8)
jal x0 -140
lw x10 -80(x8)
sw x10 -76(x8)
lw x10 -84(x8)
sw x10 -72(x8)
lw x10 -72(x8)
sw x10 -92(x8)
lw x10 -76(x8)
sw x10 -96(x8)
addi x10 x0 5
sw x10 -100(x8)
jal x0 4
lw x11 -100(x8)
addi x10 x0 0
bge x10 x11 136
jal x0 4
lw x10 -92(x8)
lw x11 -100(x8)
slli x12 x11 3
addi x11 x8 -60
add x12 x12 x11
lw x12 4(x12)
sub x13 x10 x12
lw x12 -96(x8)
srl x10 x13 x12
sub x14 x0 x12
sll x13 x13 x14
or x10 x10 x13
xor x10 x10 x12
sw x10 -92(x8)
lw x10 -96(x8)
lw x12 -100(x8)
slli x12 x12 3
add x11 x11 x12
lw x11 0(x11)
sub x12 x10 x11
lw x11 -92(x8)
srl x10 x12 x11
sub x13 x0 x11
sll x12 x12 x13
or x10 x10 x12
xor x10 x10 x11
sw x10 -96(x8)
jal x0 4
lw x10 -100(x8)
addi x10 x10 -1
sw x10 -100(x8)
jal x0 -140
lw x10 -92(x8)
lw x11 -56(x8)
sub x10 x10 x11
sw x10 -64(x8)
lw x10 -96(x8)
lw x11 -60(x8)
sub x10 x10 x11
sw x10 -68(x8)
addi x10 x0 0
lw x1 108(x2)
lw x8 104(x2)
addi x2 x2 112
lw x21, 956(x30)
lw x22, 960(x30)
lw x23, 948(x30)
lw x24, 952(x30)
jalr x0 x1 0
```

#### Bubble Sort
Input of the C code below is an integer array {58,89,71,35,6}, and output is the sorted version of this array: {6,35,58,71,89}
Our implementation of Bubble Sort also produces the same result.

```c
#include <stdio.h>
#include <stdbool.h>
int main()
{
    bool swap;
    int n=5,j,temp, i;
    int arr[5]={58,89,71,35,6};
    int out_arr[5] = {};
       for(i=0; i<n-1; i++)
        {
          swap=false;
          for(j=0;j<n-i-1;j++)
          {
            if (arr[j]>arr[j+1])
            {
                temp=arr[j];
                arr[j]=arr[j+1];
                arr[j+1]=temp;
                swap=true;
            }
          }
          if(swap == false)
          break;
        }
   for(i=0;i<n;i++)
     {       
        out_arr[i]=arr[i];
        printf(" %d", out_arr[i]);
     }
}
```
##### corresponding RISC-V Code
bubble2_new2.mem
```
addi x2 x2 -80
sw x1 76(x2)
sw x8 72(x2)
addi x8 x2 80
addi x10 x0 0
sw x10 -12(x8)
addi x11 x0 5
sw x11 -20(x8)
addi x11 x0 6
sw x11 -36(x8)
addi x11 x0 35
sw x11 -40(x8)
addi x11 x0 71
sw x11 -44(x8)
addi x11 x0 89
sw x11 -48(x8)
addi x11 x0 58
sw x11 -52(x8)
sw x10 -56(x8)
sw x10 -60(x8)
sw x10 -64(x8)
sw x10 -68(x8)
sw x10 -72(x8)
sw x10 -32(x8)
jal x0 4
lw x10 -32(x8)
lw x11 -20(x8)
addi x11 x11 -1
bge x10 x11 224
jal x0 4
addi x10 x0 0
sb x10 -13(x8)
sw x10 -24(x8)
jal x0 4
lw x10 -24(x8)
lw x12 -20(x8)
lw x11 -32(x8)
xori x11 x11 -1
add x11 x11 x12
bge x10 x11 136
jal x0 4
lw x10 -24(x8)
slli x11 x10 2
addi x10 x8 -52
add x10 x10 x11
lw x11 0(x10)
lw x10 4(x10)
bge x10 x11 84
jal x0 4
lw x10 -24(x8)
slli x10 x10 2
addi x12 x8 -52
add x10 x10 x12
lw x10 0(x10)
sw x10 -28(x8)
lw x10 -24(x8)
slli x10 x10 2
add x11 x12 x10
lw x10 4(x11)
sw x10 0(x11)
lw x10 -28(x8)
lw x11 -24(x8)
slli x11 x11 2
add x11 x11 x12
sw x10 4(x11)
addi x10 x0 1
sb x10 -13(x8)
jal x0 4
jal x0 4
lw x10 -24(x8)
addi x10 x10 1
sw x10 -24(x8)
jal x0 -152
lbu x10 -13(x8)
andi x10 x10 1
addi x11 x0 0
bne x10 x11 12
jal x0 4
jal x0 24
jal x0 4
lw x10 -32(x8)
addi x10 x10 1
sw x10 -32(x8)
jal x0 -232
addi x10 x0 0
sw x10 -32(x8)
jal x0 4
lw x10 -32(x8)
lw x11 -20(x8)
bge x10 x11 60
jal x0 4
lw x10 -32(x8)
slli x12 x10 2
addi x10 x8 -52
add x10 x10 x12
lw x10 0(x10)
addi x11 x8 -72
add x11 x11 x12
sw x10 0(x11)
jal x0 4
lw x10 -32(x8)
addi x10 x10 1
sw x10 -32(x8)
jal x0 -64
lw x10 -12(x8)
lw x1 76(x2)
lw x8 72(x2)
addi x2 x2 80
lw x21, 972(x30)
lw x22, 976(x30)
lw x23, 980(x30)
lw x24, 984(x30)
lw x25, 988(x30)
jalr x0 x1 0
```

## FPGA implementation

Switches, LED, and two buttons are used to demonstrate the project on the FPGA board.

**16 bit input switches**

The 16 switches represent the lower 16 bits of the value user wants to enter, and the value the user wants to store is stored in the dmem address 0x00100010 by toggling the 16 switches.

**16 bit output LEDs**

The 16 LEDs show the lower 16 bits of the value at address 0x00100014 in dmem in real time.

**left button for reset** 

Resets the processor when the button is pressed.
Reset signal does not remain high after the button is released.

**right button for enable**

Enables the processor when the button is pressed and released.
Enable signal remains high after the button is released.
Enable signal becomes and remains low after the button is pressed and released again.

## References

- C to RICS V

  https://godbolt.org/

- RISC V to machine code

  https://venus.kvakil.me/

- online simulation RISC 

  https://www.cs.cornell.edu/courses/cs3410/2019sp/riscv/interpreter/

- C codes are modified from ChatGPT

  

  

  
  
  
