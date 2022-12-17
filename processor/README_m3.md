# Project Milestone 2 #

### Group_03 members: ###

Xiao Ding (NetID:xd2076),
Xinran Tang (NetID:xt2191),
Qing Xiang (NetID:qx657)



## Top Module - Processor ##



## Testbench/Simulation

### single instruction

#### Test 1

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



#### Test 2

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



### Complex Functions

Both complex functions are written in C and translated to RICS V assembly language and then further translated to machine code.

#### RC5

```c
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define W 16 // word size, in bits
#define R 5 // number of rounds
#define B 32 // number of bytes in key
#define L (B/4) // number of words in key

typedef unsigned long word;

void rc5_encrypt(word *pt, word *ct, word *s);
void rc5_decrypt(word *ct, word *pt, word *s);

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
    
  // encrypt plaintext pt[]
  rc5_encrypt(pt, ct, s);
  // decrypt ciphertext ct[]
  rc5_decrypt(ct, pt, s);
  return 0;
}

int rotateLeft(word n, word d)
{
  return (n << d)|(n >> (32 - d));
}

int rotateRight(word n, word d)
{
  return (n >> d)|(n << (32 - d));
}

void rc5_encrypt(word *pt, word *ct, word *s) {
  int i;
  word A_array = pt[0] + s[0];
  word B_array = pt[1] + s[1];
  for (i = 1; i <= R; i++) {
    A_array = (rotateLeft((A_array ^ B_array), B_array)) + s[2*i];
    B_array = (rotateLeft((B_array ^ A_array), A_array)) + s[2*i+1];
  }
  ct[0] = A_array; ct[1] = B_array;
}

void rc5_decrypt(word *ct, word *pt, word *s) {
  int i;
  word B_array = ct[1];
  word A_array = ct[0];
  for (i = R; i > 0; i--) {
    B_array = (rotateRight((B_array - s[2*i+1]), A_array)) ^ A_array;
    A_array = (rotateRight((A_array - s[2*i]), B_array)) ^ B_array;

  }
  pt[1] = B_array - s[1]; pt[0] = A_array - s[0];
}



```



#### Bubble Sort

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



## FPGA implementation

Switches, LED, and two buttons are used to demonstrate the project.

**16 bit input switches**

The 16 switches represent the lower 16 bits of the value user wants to enter, and the value the user wants to store is stored in the dmem address 0x00100010 by toggling the 16 switches.

**16 bit output LEDs**

The 16 LEDs show the lower 16 bits of the value at address 0x00100014 in dmem in real time.

**left button for reset** 



**right button for enable**











## Reference

- C to RICS V

  https://godbolt.org/

- RISC V to machine code

  https://venus.kvakil.me/

- online simulation RISC 

  https://www.cs.cornell.edu/courses/cs3410/2019sp/riscv/interpreter/

  

  