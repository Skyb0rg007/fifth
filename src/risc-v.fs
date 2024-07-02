\ RISC-V Assembler DSL

\ 32-bit addressing
' HERE ALIAS THERE
CELL 4 = [IF]
' CELL  ALIAS TCELL
' CELLS ALIAS TCELLS
' @     ALIAS T@
' !     ALIAS T!
' ,     ALIAS T,
' C@    ALIAS TC@
' C!    ALIAS TC!
' C,    ALIAS TC,
[ELSE]
4 CONSTANT TCELL
: TCELLS 2 LSHIFT ;
: T@ @ $ffffffff AND ;
: T! DUP @ $ffffffff INVERT AND ROT $ffffffff AND OR SWAP ! ;
: T, HERE T! TCELL ALLOT ;
' C@ ALIAS TC@
' C! ALIAS TC!
' C, ALIAS TC,
[THEN]

\ Assembler
: check-range ( u -- )
    WITHIN 0= ABORT" argument out of range" ;

\ Opcode
: asm-op ( n -- code )
    DUP 0 $80 check-range ;

\ Destination register
: asm-rd ( u code -- code )
    OVER 0 $20 check-range
    SWAP 7 LSHIFT OR ;

\ First source register
: asm-rs1 ( u code -- code )
    OVER 0 $20 check-range
    SWAP 15 LSHIFT OR ;

\ Second source register
: asm-rs2 ( u code -- code )
    OVER 0 $20 check-range
    SWAP 20 LSHIFT OR ;

\ 3-bit functionality slot
: asm-funct3 ( u code -- code )
    OVER 0 $8 check-range
    SWAP 12 LSHIFT OR ;

\ 7-bit functionality slot
: asm-funct7 ( u code -- code )
    OVER 0 $80 check-range
    SWAP 25 LSHIFT OR ;

\ I-type immediate
: asm-I-imm ( u code -- code )
    OVER 0 $1000 check-range
    SWAP 20 LSHIFT OR ;

\ U-type immediate
: asm-U-imm ( u code -- code )
    OVER 0 $100000 check-range
    SWAP 12 LSHIFT OR ;

\ S-type immediate
: asm-S-imm ( u code -- code )
    OVER -$800 $800 check-range
    OVER $1f AND 7 LSHIFT OR
    SWAP 5 RSHIFT $7f AND 25 LSHIFT OR ;

\ B-type immediate
: asm-B-imm ( u code -- code )
    -1 ABORT" Not yet implemented" ;

\ | funct7 | rs2 | rs1 | funct3 | rd | opcode |
: asm-R-type ( "name" opcode funct3 funct7 )
    CREATE ROT , , ,
    DOES> ( rd rs1 rs2 -- )
        DUP CELL+ 2@ ROT @
        asm-op asm-funct7 asm-funct3 asm-rs2 asm-rs1 asm-rd T, ;

\ | imm[11:0] | rs1 | funct3 | rd | opcode |
: asm-I-type ( "name" opcode funct3 -- )
    CREATE SWAP 2,
    DOES> ( rd imm rs -- )
        2@ asm-op asm-funct3 asm-rs1 asm-I-imm asm-rd T, ;

\ | imm[11:5] | rs2 | rs1 | funct3 | imm[4:0] | opcode |
: asm-S-type ( "name" opcode funct3 -- )
    CREATE SWAP 2,
    DOES> ( src base offset -- )
        2@ asm-op asm-funct3 asm-S-imm asm-rs1 asm-rs2 T, ;

\ | imm[12|10:5] | rs2 | rs1 | funct3 | imm[4:1|11] | opcode |
: asm-B-type ( "name" opcode funct3 -- )
    CREATE SWAP 2,
    DOES> ( src1 src2 offset -- )
        2@ asm-op asm-funct3 asm-B-imm asm-rs1 asm-rs2 T, ;

\ | imm[31:12] | opcode |
: asm-U-type ( "name" opcode -- )
    CREATE ,
    DOES> ( rd imm -- )
        @ asm-op asm-U-imm asm-rd T, ;

\ Registers
$00 CONSTANT x0  $01 CONSTANT x1  $02 CONSTANT x2  $03 CONSTANT x3
$04 CONSTANT x4  $05 CONSTANT x5  $06 CONSTANT x6  $07 CONSTANT x7
$08 CONSTANT x8  $09 CONSTANT x9  $0a CONSTANT x10 $0b CONSTANT x11
$0c CONSTANT x12 $0d CONSTANT x13 $0e CONSTANT x14 $0f CONSTANT x15
$10 CONSTANT x16 $11 CONSTANT x17 $12 CONSTANT x18 $13 CONSTANT x19
$14 CONSTANT x20 $15 CONSTANT x21 $16 CONSTANT x22 $17 CONSTANT x23
$18 CONSTANT x24 $19 CONSTANT x25 $1a CONSTANT x26 $1b CONSTANT x27
$1c CONSTANT x28 $1d CONSTANT x29 $1e CONSTANT x30 $1f CONSTANT x31

\ Register Aliases
\ x0 CONSTANT a0

\ Integer Register-Immediate Instructions
%0010011 %000 asm-I-type addi, ( dest src imm -- )
%0010011 %010 asm-I-type slti,
%0010011 %011 asm-I-type sltiu,
%0010011 %100 asm-I-type xori,
%0010011 %110 asm-I-type ori,
%0010011 %111 asm-I-type andi,
%0010011 %001 %0000000 asm-R-type slli, ( dest src shift -- )
%0010011 %101 %0000000 asm-R-type srli,
%0010011 %101 %0100000 asm-R-type srai,
%0110111 asm-U-type lui,   ( dest imm -- )
%0010111 asm-U-type auipc, ( dest imm -- )

\ Integer Register-register Instructions
%0110011 %000 %0000000 asm-R-type add, ( dest src1 src2 -- )
%0110011 %000 %0100000 asm-R-type sub,
%0110011 %001 %0000000 asm-R-type sll,
%0110011 %010 %0000000 asm-R-type slt,
%0110011 %011 %0000000 asm-R-type sltu,
%0110011 %100 %0000000 asm-R-type xor,
%0110011 %101 %0000000 asm-R-type srl,
%0110011 %101 %0100000 asm-R-type sra,
%0110011 %110 %0100000 asm-R-type or,
%0110011 %111 %0100000 asm-R-type and,

\ Unconditional Jumps
: jal, ( dest offset -- )
    DUP 1 AND ABORT" jal offset must be 2-byte aligned"
    DUP -$80000 $80000 check-range
    %1101111 asm-op
    OVER 20 LSHIFT $7fe00000 AND OR
    OVER 10 LSHIFT $100000 AND OR
    OVER 19 RSHIFT $1 AND 31 RSHIFT OR
    SWAP 1 LSHIFT $1ff000 AND OR
    asm-rd T, ;
%1100111 %000 asm-I-type jalr, ( dest base offset -- )
\ jalr x1, 8(x2) -> x1 x2 8 jalr,

\ Conditional Branches
%1100011 %000 asm-B-type beq,  ( src1 src2 offset -- )
%1100011 %001 asm-B-type bne,
%1100011 %100 asm-B-type blt,
%1100011 %101 asm-B-type bge,
%1100011 %110 asm-B-type bltu,
%1100011 %111 asm-B-type bgeu,

\ Load and Store Instructions
%0000011 %000 asm-I-type lb, \ lb x1, 8(x2) -> x1 x2 8 lb,
%0000011 %001 asm-I-type lh,
%0000011 %010 asm-I-type lw,
%0000011 %100 asm-I-type lbu,
%0000011 %101 asm-I-type lhu,
%0100011 %000 asm-S-type sb, \ sb x1, 8(x2) -> x1 x2 8 sb,
%0100011 %001 asm-S-type sh,
%0100011 %010 asm-S-type sw,

\ Pseudoinstructions
: nop, x0 x0 0 addi, ;

VARIABLE start
VARIABLE fileid

: start-output ( c-addr u -- )
    W/O BIN CREATE-FILE THROW fileid !
    THERE start ! ;

: end-output ( config -- )
    start @ THERE OVER - fileid @ WRITE-FILE THROW
    fileid @ CLOSE-FILE THROW
    0 fileid ! 0 start ! ;

S" out.bin" start-output
x8 $deae jal,
end-output

S" test.s" W/O BIN CREATE-FILE THROW CONSTANT testfile
S\" jal x8, 0xd\n" testfile WRITE-FILE THROW
testfile CLOSE-FILE THROW

S" riscv32-unknown-elf-gcc test.s -c -o test.elf" SYSTEM
S" riscv32-unknown-elf-objcopy -O binary test.elf test.bin" SYSTEM

S" xxd out.bin" SYSTEM
S" xxd test.bin" SYSTEM

BYE
