;; vim: ft=nasm

%include "macros.nasm"

;; Register usage
; rax = misc
; rbx = misc
; rcx = misc
; rdx = misc
; rsi = next word to execute
; rsp = data stack
; rbp = return stack
; r8-15 = misc

;; Data used
        section .bss
; Used to store return stack
return_stack:
        resb 8192
return_stack_top:
return_stack_len equ $ - return_stack

; Used to load input
input_buffer:
        resb 4096
input_buffer_len equ $ - input_buffer

; Used as the main data
data_stack:
        resb 65536
data_stack_top:
data_stack_len equ $ - data_stack

;; Variables used
defvar "STATE", FTH_STATE ; Interpreting or compiling?
defvar "HERE", FTH_HERE, data_stack_top ; Next free memory address
defvar "LATEST", FTH_LATEST ; TODO - put last defined word in here
defvar "S0", FTH_SZ, return_stack_top
defvar "BASE", FTH_BASE, 10

;; Colon definition interpreter
        section .text
        align 8
DO_COLON:
        RSP_PUSH rsi
        add rax, 8
        mov rsi, rax
        NEXT


        section .text
        global _start
_start:
        cld ; Clear the DF flag
        
        ; Initialization
        mov rbp, return_stack
        mov rsp, data_stack
        mov rsi, cold_start
        NEXT

        section .rodata
cold_start:
        ; TODO
        dq 0

defword "LIT", FTH_LIT
        lodsq
        push rax
        NEXT

defword "RSP!", FTH_RSPSTORE
        pop rbp
        NEXT

defcode "INTERPRET", FTH_INTERPRET
        ; TODO
        NEXT

defword "BRANCH", FTH_BRANCH
        add rsi, [rsi]
        NEXT

defword "0BRANCH", FTH_0BRANCH
        pop rax
        test rax, rax
        jz fth_0branch_branch
        lodsq
        NEXT
fth_0branch_branch:
        add rsi, [rsi]
        NEXT

defword "QUIT", FTH_QUIT
        ; $return_stack RSP!
        dq FTH_LIT, return_stack, FTH_RSPSTORE
        ; INTERPRET the code
        dq FTH_INTERPRET
        ; Loop forever
        dq FTH_BRANCH, -16

