# 8-bit CPU
A Von Neumann architecture 8-bit CPU.  
**Instruction format:** [5-bit opcode, 8-bit operand]  
**REMOVED ABILITY TO MODIFY PC DIRECTLY**

---

## Registers

| Register | Encoding | Description |
|----------|-----------------------------|-------------|
| Wreg     | Standalone                  | working register  |
| PC       | Standalone                  | program counter   |
| R0       | 00000000                    | general-purpose 0 |
| R1       | 00000001                    | general-purpose 1 |
| R2       | 00000010                    | general-purpose 2 |
| R3       | 00000011                    | general-purpose 3 |
| R4       | 00000100                    | general-purpose 4 |
| SP       | 00000101                    | stack pointer |
| MD       | 00000110                    | memory data |
| MA       | 00000111                    | memory address |

---

## ISA

### Data commands

| Instruction       | Opcode (5-bit) | Operand (8-bit) | Description |
|------------------|----------------|----------------|-------------|
| `NOP`            | 00000          | –              | no operation |
| `LOADI Wreg, imm` | 00001          | 8-bit immediate | load immediate into Wreg |
| `LOADA Wreg, [addr]` | 00010      | 8-bit address  | load from memory to Wreg |
| `STORE Wreg, [addr]` | 00011      | 8-bit address  | store Wreg to memory |
| `MOV Wreg, Rn`   | 00100          | register code  | move Rn to Wreg |
| `MOVW Rn, Wreg`  | 00101          | register code  | move Wreg to Rn |
| `PUSH Wreg`      | 00110          | –              | push Wreg onto stack |
| `POP Wreg`       | 00111          | –              | pop stack into Wreg |

### ALU commands

| Instruction       | Opcode (5-bit) | Operand (8-bit) | Description |
|------------------|----------------|----------------|-------------|
| `ADD Wreg, Rn`   | 01000          | register code  | add Rn to Wreg |
| `SUB Wreg, Rn`   | 01001          | register code  | subtract Rn from Wreg |
| `AND Wreg, Rn`   | 01010          | register code  | AND Rn with Wreg |
| `OR Wreg, Rn`    | 01011          | register code  | OR Rn with Wreg |
| `XOR Wreg, Rn`   | 01100          | register code  | XOR Rn with Wreg |
| `NOT Wreg`       | 01101          | –              | invert Wreg |
| `INC Wreg`       | 01110          | –              | increment Wreg |
| `DEC Wreg`       | 01111          | –              | decrement Wreg |

### jump commands

| Instruction       | Opcode (5-bit) | Operand (8-bit) | Description |
|------------------|----------------|----------------|-------------|
| `JMP [addr]`     | 10000          | 8-bit address  | jump to address |
| `JZ [addr]`      | 10001          | 8-bit address  | jump if zero |
| `JC [addr]`      | 10010          | 8-bit address  | jump if carry |
| `HLT`            | 10011          | –              | halt CPU |

### maybwe for later

| Instruction       | Opcode (5-bit) | Operand (8-bit) | Description |
|------------------|----------------|----------------|-------------|
| `IN Wreg`        | 10100          | –              | read byte into Wreg |
| `OUT Wreg`       | 10101          | –              | write Wreg to output|


## ALU  
Handles everything that is in the ALU commands section.  

![alt text](image-1.png)  
- INPUTS
    - ALU OP 2-1-0
    - Wreg  
    - Rn
- OUTPUTS
    - Result (8 bit, goes to data bus)
    - carryF  
    - zeroF

## RAM  
Read only memory, program memory.  

![alt text](image-2.png)  
- INPUTS
    - addr (8 bits)
    - enable (enables reading addr to output)
- OUTPUTS
    - data (8 bits, should go to data bus)  
    
## ROM  
RAM, might come in useful later for inputs/outputs, no real use now  

![alt text](image-3.png)  
- INPUTS
    - addr   (8 bits)
    - dataIn (8 bits)  
    - readEnable  (enables reading from addr)
    - writeEnable (enables writing dataIn to dataIN) 
    - clk  
- OUTPUTS
    - dataOut (8 bit, goes to data bus)

## REGISTERS  
Contains all registers, including Wreg, PC and SP for now (will be kept if it doesn't prove to be too much of a technical difficulty)  

![alt text](image-4.png)  
- INPUTS
    - dataIn (8 bits)  
    - writeSelect
    - writeEnable 
    - readSelect
    - clk  
    - clear
- OUTPUTS
    - dataOut (8 bit, goes to data bus)  

## CONTROL UNIT  
- INPUTS
    - INSTRUCTION (8 bits)  
    - clk  
    - zeroF  
    - carryF  
- OUTPUTS    
    - Wreg_WE  
    - Wreg_RE  
    - REG_WE  
    - REG_SEL  
    - RAM_RE  
    - RAM_WE  
    - RAM_ADDR_EN  
    - ALU_OP (3 bits)  
    - ALU_EN  
    - PC_LOAD  
    - PC_EN  
    - SP_INC  
    - SP_DEC  
    - STACK_WE  
    - STACK_RE  
    - HALT      
  
#### DATA COMMAND SIGNALS
| Instruction | Wreg_WE | Wreg_RE | REG_WE | REG_SEL | RAM_RE | RAM_WE | RAM_ADDR_EN | ALU_OP | ALU_EN | PC_LOAD | PC_EN | SP_INC | SP_DEC | STACK_WE | STACK_RE | HALT |
| ----------- | ------- | ------- | ------ | ------- | ------ | ------ | ----------- | ------ | ------ | ------- | ----- | ------ | ------ | -------- | -------- | ---- |
| NOP         | 0       | 0       | 0      | –       | 0      | 0      | 0           | –      | 0      | 0       | 1     | 0      | 0      | 0        | 0        | 0    |
| LOADI       | 1       | 0       | 0      | –       | 0      | 0      | 0           | –      | 0      | 0       | 1     | 0      | 0      | 0        | 0        | 0    |
| LOADA       | 1       | 0       | 0      | –       | 1      | 0      | 1           | –      | 0      | 0       | 1     | 0      | 0      | 0        | 0        | 0    |
| STORE       | 0       | 1       | 0      | –       | 0      | 1      | 1           | –      | 0      | 0       | 1     | 0      | 0      | 0        | 0        | 0    |
| MOV W,Rn    | 1       | 0       | 0      | Rn      | 0      | 0      | 0           | –      | 0      | 0       | 1     | 0      | 0      | 0        | 0        | 0    |
| MOVW Rn,W   | 0       | 1       | 1      | Rn      | 0      | 0      | 0           | –      | 0      | 0       | 1     | 0      | 0      | 0        | 0        | 0    |
| PUSH        | 0       | 1       | 0      | –       | 0      | 0      | 0           | –      | 0      | 0       | 1     | 1      | 0      | 1        | 0        | 0    |
| POP         | 1       | 0       | 0      | –       | 0      | 0      | 0           | –      | 0      | 0       | 1     | 0      | 1      | 0        | 1        | 0    |


#### ALU COMMAND SIGNALS  
| Instruction | Wreg_WE | Wreg_RE | REG_WE | REG_SEL | RAM_RE | RAM_WE | RAM_ADDR_EN | ALU_OP | ALU_EN | PC_LOAD | PC_EN | SP_INC | SP_DEC | STACK_WE | STACK_RE | HALT |
| ----------- | ------- | ------- | ------ | ------- | ------ | ------ | ----------- | ------ | ------ | ------- | ----- | ------ | ------ | -------- | -------- | ---- |
| ADD W,Rn    | 1       | 0       | 0      | Rn      | 0      | 0      | 0           | 000    | 1      | 0       | 1     | 0      | 0      | 0        | 0        | 0    |
| SUB W,Rn    | 1       | 0       | 0      | Rn      | 0      | 0      | 0           | 001    | 1      | 0       | 1     | 0      | 0      | 0        | 0        | 0    |
| AND W,Rn    | 1       | 0       | 0      | Rn      | 0      | 0      | 0           | 010    | 1      | 0       | 1     | 0      | 0      | 0        | 0        | 0    |
| OR W,Rn     | 1       | 0       | 0      | Rn      | 0      | 0      | 0           | 011    | 1      | 0       | 1     | 0      | 0      | 0        | 0        | 0    |
| XOR W,Rn    | 1       | 0       | 0      | Rn      | 0      | 0      | 0           | 100    | 1      | 0       | 1     | 0      | 0      | 0        | 0        | 0    |
| NOT W       | 1       | 0       | 0      | –       | 0      | 0      | 0           | 101    | 1      | 0       | 1     | 0      | 0      | 0        | 0        | 0    |
| INC W       | 1       | 0       | 0      | –       | 0      | 0      | 0           | 110    | 1      | 0       | 1     | 0      | 0      | 0        | 0        | 0    |
| DEC W       | 1       | 0       | 0      | –       | 0      | 0      | 0           | 111    | 1      | 0       | 1     | 0      | 0      | 0        | 0        | 0    |


#### JUMP COMMAND SIGNALS 
| Instruction | Wreg_WE | Wreg_RE | REG_WE | REG_SEL | RAM_RE | RAM_WE | RAM_ADDR_EN | ALU_OP | ALU_EN | PC_LOAD       | PC_EN | SP_INC | SP_DEC | STACK_WE | STACK_RE | HALT |
| ----------- | ------- | ------- | ------ | ------- | ------ | ------ | ----------- | ------ | ------ | ------------- | ----- | ------ | ------ | -------- | -------- | ---- |
| JMP addr    | 0       | 0       | 0      | –       | 0      | 0      | 0           | –      | 0      | 1             | 0     | 0      | 0      | 0        | 0        | 0    |
| JZ addr     | 0       | 0       | 0      | –       | 0      | 0      | 0           | –      | 0      | 1 if zeroF=1  | 0     | 0      | 0      | 0        | 0        | 0    |
| JC addr     | 0       | 0       | 0      | –       | 0      | 0      | 0           | –      | 0      | 1 if carryF=1 | 0     | 0      | 0      | 0        | 0        | 0    |
| HLT         | 0       | 0       | 0      | –       | 0      | 0      | 0           | –      | 0      | 0             | 0     | 0      | 0      | 0        | 0        | 1    |
  
Control unit works.  

pc.out->ROM.addr  
pc.out->Adder.A  
constant(1)->Adder.B  
Adder.Result-> pc.D  
clk->pc.clk  
ROM.data->ControlledBuffer.IN  
ControlledBuffer.OUT->DATABUS
ControlUnit.PC_EN->ControlledBuffer.enable  
ControlUnit.PC_EN->ROM.enable       
ROM.data->Splitter (outputs operand as 8bit, opcode as 5 bit)  
Splitter.opcode->ControlUnit.opcode  
Splitter.operand->ControlUnit.operand  


# HALT AND NOP ARE WORKING FROM PROGRAM MEMORY
# LOADI and INC and DEC WORK  
# MOVW AND MOV WORK, SO DOES REG INTO ALU