\ RISC-V Assembler DSL

VOCABULARY RISC-V

: (code)
    ALSO RISC-V
    GET-ORDER >R = ABORT" Assembler is activated!"
    R> 2 - 0 ?DO DROP LOOP ;

: (end-code)
    ALSO RISC-V
    GET-ORDER >R <> ABORT" Assembler isn't activated!"
    R> 2 - 0 ?DO DROP LOOP
    PREVIOUS PREVIOUS ;

S" a.out" W/O BIN CREATE-FILE THROW CONSTANT outfile

RISC-V DEFINITIONS

\ 1000 ALLOT
\ 
\ : t, ( x -- ) there 

VARIABLE tmp
: t, ( x -- ) tmp ! tmp 4 CHARS outfile WRITE-FILE THROW ;

\ Registers
%00000 CONSTANT x0
%00001 CONSTANT x1
%00010 CONSTANT x2
%00011 CONSTANT x3
%00100 CONSTANT x4
%00101 CONSTANT x5
%00110 CONSTANT x6
%00111 CONSTANT x7
%01000 CONSTANT x8
%01001 CONSTANT x9
%01010 CONSTANT x10
%01011 CONSTANT x11
%01100 CONSTANT x12
%01101 CONSTANT x13
%01110 CONSTANT x14
%01111 CONSTANT x15
%10000 CONSTANT x16
%10001 CONSTANT x17
%10010 CONSTANT x18
%10011 CONSTANT x19
%10100 CONSTANT x20
%10101 CONSTANT x21
%10110 CONSTANT x22
%10111 CONSTANT x23
%11000 CONSTANT x24
%11001 CONSTANT x25
%11010 CONSTANT x26
%11011 CONSTANT x27
%11100 CONSTANT x28
%11101 CONSTANT x29
%11110 CONSTANT x30
%11111 CONSTANT x31

\ Register ABI names
x0  CONSTANT zero \ Hard-wired zero
x1  CONSTANT ra   \ Return address
x2  CONSTANT sp   \ Stack pointer
x3  CONSTANT gp   \ Global pointer
x4  CONSTANT tp   \ Thread pointer
x5  CONSTANT t0   \ Temporary/alternate link register
x6  CONSTANT t1   \ Temporaries
x7  CONSTANT t2
x28 CONSTANT t3
x29 CONSTANT t4
x30 CONSTANT t5
x31 CONSTANT t6
x8  CONSTANT fp   \ Frame pointer
x8  CONSTANT s0   \ Saved registers
x9  CONSTANT s1
x18 CONSTANT s2
x19 CONSTANT s3
x20 CONSTANT s4
x21 CONSTANT s5
x22 CONSTANT s6
x23 CONSTANT s7
x24 CONSTANT s8
x25 CONSTANT s9
x26 CONSTANT s10
x27 CONSTANT s11
1 [IF]
x10 CONSTANT a0   \ Function arguments/return values
x11 CONSTANT a1
x12 CONSTANT a2   \ Function arguments
x13 CONSTANT a3
x14 CONSTANT a4
x15 CONSTANT a5
x16 CONSTANT a6
x17 CONSTANT a7
[THEN]

: reg>string ( reg -- c-addr u )
    S>D <# [CHAR] x HOLD #s #> ;

: reg. ( reg -- )
    reg>string TYPE ;

\ Base opcodes
%0000011 CONSTANT OP:LOAD
%0100011 CONSTANT OP:STORE
%1100011 CONSTANT OP:BRANCH
%1100111 CONSTANT OP:JALR
%0001111 CONSTANT OP:MISC-MEM
%1101111 CONSTANT OP:JAL
%0010011 CONSTANT OP:OP-IMM
%0110011 CONSTANT OP:OP
%1110011 CONSTANT OP:SYSTEM
%0010111 CONSTANT OP:AUIPC
%0110111 CONSTANT OP:LUI

\ Base instruction set
: R-type ( funct7 rs2 rs1 funct3 rd op -- )
    $7f AND
    SWAP $1f AND  7 LSHIFT OR
    SWAP $07 AND 12 LSHIFT OR
    SWAP $1f AND 15 LSHIFT OR
    SWAP $1f AND 20 LSHIFT OR
    SWAP $7f AND 25 LSHIFT OR
    t, ;

: I-type ( imm rs1 funct3 rd op -- )
    $7f AND
    SWAP $1f AND  7 LSHIFT OR
    SWAP $07 AND 12 LSHIFT OR
    SWAP $1f AND 15 LSHIFT OR
    SWAP $fff AND 20 LSHIFT OR
    t, ;

: S-type ( imm rs2 rs1 funct3 op -- )
    $7f AND
    SWAP $07 AND 12 LSHIFT OR
    SWAP $1f AND 15 LSHIFT OR
    SWAP $1f AND 20 LSHIFT OR
    SWAP $fff AND
        DUP $1f AND 7 LSHIFT
        SWAP 5 RSHIFT 25 LSHIFT OR
        OR
    t, ;

: B-type ( imm rs2 rs1 funct3 op -- )
    $7f AND
    SWAP $07 AND 12 LSHIFT OR
    SWAP $1f AND 15 LSHIFT OR
    SWAP $1f AND 20 LSHIFT OR
    SWAP 1 RSHIFT $fff AND
        DUP $200 AND 3 RSHIFT OR
        OVER $f AND 8 LSHIFT
        OVER $400 AND 21 LSHIFT OR
        SWAP $1f0 AND 20 LSHIFT OR
        OR
    t, ;

: U-type ( imm rd op -- )
    $7f AND
    SWAP $1f AND 7 LSHIFT OR
    SWAP $fffff000 AND OR
    t, ;

: J-type ( imm rd op -- instr )
    $7f AND
    SWAP $1f AND 7 LSHIFT OR
    TRUE ABORT" NYI"
    t, ;

\ Base Instructions
: lui   ( imm rd -- ) OP:LUI U-type ;
: auipc ( imm rd -- ) OP:AUIPC U-type ;
: jal   ( imm rd -- ) OP:JAL J-type ;
: jalr  ( imm rd -- ) OP:JALR J-type ;
: beq   ( imm rs2 rs1 -- ) %000 OP:BRANCH B-type ;
: bne   ( imm rs2 rs1 -- ) %001 OP:BRANCH B-type ;
: blt   ( imm rs2 rs1 -- ) %100 OP:BRANCH B-type ;
: bge   ( imm rs2 rs1 -- ) %101 OP:BRANCH B-type ;
: bltu  ( imm rs2 rs1 -- ) %110 OP:BRANCH B-type ;
: bgeu  ( imm rs2 rs1 -- ) %111 OP:BRANCH B-type ;
: lb    ( imm rs rd -- ) %000 SWAP OP:LOAD I-type ;
: lh    ( imm rs rd -- ) %001 SWAP OP:LOAD I-type ;
: lw    ( imm rs rd -- ) %010 SWAP OP:LOAD I-type ;
: lbu   ( imm rs rd -- ) %100 SWAP OP:LOAD I-type ;
: lhu   ( imm rs rd -- ) %101 SWAP OP:LOAD I-type ;
: sb    ( imm rs2 rs1 -- ) %000 OP:STORE S-type ;
: sh    ( imm rs2 rs1 -- ) %001 OP:STORE S-type ;
: sw    ( imm rs2 rs1 -- ) %010 OP:STORE S-type ;
: addi  ( imm rs rd -- ) %000 SWAP OP:OP-IMM I-type ;
: slti  ( imm rs rd -- ) %010 SWAP OP:OP-IMM I-type ;
: sltiu ( imm rs rd -- ) %011 SWAP OP:OP-IMM I-type ;
: xori  ( imm rs rd -- ) %100 SWAP OP:OP-IMM I-type ;
: ori   ( imm rs rd -- ) %110 SWAP OP:OP-IMM I-type ;
: andi  ( imm rs rd -- ) %111 SWAP OP:OP-IMM I-type ;
: slli  ( shamt rs1 rd -- ) ROT $1f AND -ROT %001 SWAP OP:OP-IMM I-type ;
: srli  ( shamt rs1 rd -- ) ROT $1f AND -ROT %101 SWAP OP:OP-IMM I-type ;
: srai  ( shamt rs1 rd -- ) ROT $1f AND %0100000 OR -ROT %101 SWAP OP:OP-IMM I-type ;
: add   ( rs2 rs1 rd -- ) >R %0000000 -ROT %000 R> OP:OP R-type ;
: sub   ( rs2 rs1 rd -- ) >R %0100000 -ROT %000 R> OP:OP R-type ;
: slt   ( rs2 rs1 rd -- ) >R %0000000 -ROT %010 R> OP:OP R-type ;
: sltu  ( rs2 rs1 rd -- ) >R %0000000 -ROT %011 R> OP:OP R-type ;
\ : xor   ( rs2 rs1 rd -- ) >R %0000000 -ROT %100 R> OP:OP R-type ;
: srl   ( rs2 rs1 rd -- ) >R %0000000 -ROT %101 R> OP:OP R-type ;
: sra   ( rs2 rs1 rd -- ) >R %0100000 -ROT %101 R> OP:OP R-type ;
\ : or    ( rs2 rs1 rd -- ) >R %0000000 -ROT %110 R> OP:OP R-type ;
\ : and   ( rs2 rs1 rd -- ) >R %0000000 -ROT %111 R> OP:OP R-type ;
: fence ( pred succ -- ) $f AND SWAP $f AND 4 LSHIFT OR 0 0 0 OP:MISC-MEM I-type ;
: fence.i ( -- ) 0 0 fence ;
: ecall ( -- ) 0 0 0 0 OP:SYSTEM I-type ;
: ebreak ( -- ) 1 0 0 0 OP:SYSTEM I-type ;
: csrrw ( csr rs1 rd -- ) %001 SWAP OP:SYSTEM I-type ;
: csrrs ( csr rs1 rd -- ) %010 SWAP OP:SYSTEM I-type ;
: csrrc ( csr rs1 rd -- ) %011 SWAP OP:SYSTEM I-type ;
: csrrwi ( csr zimm rd -- ) %101 SWAP OP:SYSTEM I-type ;
: csrrsi ( csr zimm rd -- ) %110 SWAP OP:SYSTEM I-type ;
: csrrci ( csr zimm rd -- ) %111 SWAP OP:SYSTEM I-type ;
: mul    ( rs2 rs1 rd -- ) >R %0000001 -ROT %000 R> OP:OP R-type ;
: mulh   ( rs2 rs1 rd -- ) >R %0000001 -ROT %001 R> OP:OP R-type ;
: mulhsu ( rs2 rs1 rd -- ) >R %0000001 -ROT %010 R> OP:OP R-type ;
: mulhu  ( rs2 rs1 rd -- ) >R %0000001 -ROT %011 R> OP:OP R-type ;
: div    ( rs2 rs1 rd -- ) >R %0000001 -ROT %100 R> OP:OP R-type ;
: divu   ( rs2 rs1 rd -- ) >R %0000001 -ROT %101 R> OP:OP R-type ;
: rem    ( rs2 rs1 rd -- ) >R %0000001 -ROT %110 R> OP:OP R-type ;
: remu   ( rs2 rs1 rd -- ) >R %0000001 -ROT %111 R> OP:OP R-type ;

\ pseudo-instructions
: la ( rd symbol -- ) 2DUP auipc DUP addi ;
: nop 0 x0 x0 addi ;
\ li 
: mv ( rs rd -- x ) 0 -ROT addi ;      \ mv rd, rs == addi rd, rs, 0
: not ( rs rd -- x ) $fff -ROT xori ;  \ not rd, rs == xori rd, rs, -1
: neg ( rs rd -- x ) x0 SWAP sub ;     \ neg rd, rs == sub rd, x0, rs
: seqz ( rs rd -- x ) 1 -ROT sltiu ;   \ seqz rd, rs == sltiu rd, rs, 0
: snez ( rs rd -- x ) x0 SWAP sltu ;   \ snez rd, rs == sltu rd, x0, rs
: sltz ( rs rd -- x ) x0 -ROT slt ;    \ sltz rd, rs == slt rd, rs, x0
: sgtz ( rs rd -- x ) x0 SWAP slt ;    \ sgtz rd, rs == slt rd, x0, rs

FORTH ALSO DEFINITIONS

: compile-gcc" ( "asm" -- )
    S" temp.s" W/O BIN CREATE-FILE THROW >R
    ['] S\" EXECUTE R@ WRITE-FILE THROW
    S\" \n" R@ WRITE-FILE THROW
    R> CLOSE-FILE THROW
    S" riscv64-linux-gnu-gcc-10 -c temp.s -o temp.elf" system
    S" riscv64-linux-gnu-objcopy -O binary temp.elf test.out" system
    \ S" temp.s" DELETE-FILE THROW
    \ S" temp.elf" DELETE-FILE THROW
    ;

compile-gcc" addi a0, a0, 40\nsb a0, 323(a1)"

(code)
40 a0 a0 addi .S
323 a1 a0 sb .S
(end-code)

outfile CLOSE-FILE THROW


\ : accessor: ( offset nbits "name" -- )
\     CREATE
\         1 SWAP LSHIFT 1- SWAP ( -- mask offset ) , ,
\     DOES> ( x a-addr -- x )
\         \ ." accessing mask = " DUP CELL+ @ BASE @ >R HEX . R> BASE ! ." , offset = " DUP @ . CR
\         TUCK @ RSHIFT SWAP CELL+ @ AND
\     ;
\ 
\ 25  7 accessor: funct7
\ 20  5 accessor: rs2
\ 15  5 accessor: rs1
\ 12  3 accessor: funct3
\  7  5 accessor: rd
\ 20 12 accessor: I-imm
\ 12 21 accessor: U-imm
\  0  7 accessor: opcode
\ : S-imm ( x -- x ) DUP rd SWAP funct7 5 LSHIFT OR ;
\ 
\ : instr. ( x -- )
\     >R
\     R@ opcode CASE
\         OP:LOAD OF
\             ." LOAD"
\         ENDOF
\         OP:STORE OF
\             R@ funct3 CASE
\                 %000 OF ." sb" ENDOF
\                 %001 OF ." sh" ENDOF
\                 %010 OF ." sw" ENDOF
\                 ( default ) ." STORE"
\             ENDCASE
\             SPACE
\             R@ rs1 reg. ." , "
\             R@ rs2 reg. ." , "
\             R@ S-imm .
\         ENDOF
\         OP:BRANCH OF
\             ." BRANCH"
\         ENDOF
\         %1100111 OF ( JALR )
\             ." JALR"
\         ENDOF
\         %1101111 OF ( JAL )
\             ." JAL"
\         ENDOF
\         OP:OP-IMM OF
\             R@ funct3 CASE
\                 %000 OF ." addi"  ENDOF
\                 %001 OF ." slli"  ENDOF
\                 %010 OF ." slti"  ENDOF
\                 %011 OF ." sltiu" ENDOF
\                 %100 OF ." xori"  ENDOF
\                 %101 OF
\                     CASE
\                     ." srli"
\                     ENDCASE
\                 ENDOF
\                 %110 OF ." ori"   ENDOF
\                 %111 OF ." andi"  ENDOF
\                 ( default ) ." OP-IMM"
\             ENDCASE
\             SPACE
\             R@ rd  reg. ." , "
\             R@ rs1 reg. ." , "
\             R@ I-imm .
\         ENDOF
\         OP:OP OF
\             R@ funct7 7 LSHIFT R@ funct3 OR CASE
\                 %0000000000 OF ." add" ENDOF
\                 %0100000000 OF ." sub" ENDOF
\                 %0000000001 OF ." sll" ENDOF
\                 %0000000010 OF ." slt" ENDOF
\                 %0000000011 OF ." sltu" ENDOF
\                 %0000000100 OF ." xor" ENDOF
\                 %0000000101 OF ." srl" ENDOF
\                 %0100000101 OF ." sra" ENDOF
\                 %0000000110 OF ." or" ENDOF
\                 %0000000111 OF ." and" ENDOF
\                 ( default ) ." OP"
\             ENDCASE
\             SPACE
\         ENDOF
\         %0010111 OF ( AUIPC )
\             ." AUIPC"
\         ENDOF
\         %0110111 OF ( LUI )
\             ." lui " R@ rd reg. ." , " R@ U-imm .
\         ENDOF
\         ( default )
\             ." UNKNOWN"
\     ENDCASE
\     RDROP ;

BYE
