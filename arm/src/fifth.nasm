;; vim: ft=nasm

;; CONVENTIONS
; - words' assembly labels begin with FTH_
; - a label to word W's assembly is _W

;; Macros for defining words
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

;;
;; FIFTH return stack
;;
        section .bss
%define RETURN_STACK_SIZE 8192
return_stack:
        resb RETURN_STACK_SIZE
return_stack_top:

;;
;; FIFTH input buffer
;;
%define INPUT_BUFFER_SIZE 4096
input_buffer:
        resb INPUT_BUFFER_SIZE


;;
;; FIFTH data stack
;; 
%define DATA_SEGMENT_SIZE 65536
data_segment:
        resb DATA_SEGMENT_SIZE
data_segment_top:
        ; section .text
; ; Uses `int brk(unsigned long)' to setup FIFTH stack
; setup_data_segment:
        ; push rdi
        ; ; FTH_HERE = brk(0);
        ; xor rdi, rdi
        ; mov rax, SYS_BRK
        ; syscall
        ; mov [var_FTH_HERE], rax
        ; ; brk(FTH_HERE + INITIAL_DATA_SEGMENT_SIZE);
        ; add rax, INITIAL_DATA_SEGMENT_SIZE
        ; mov rdi, rax
        ; mov rax, SYS_BRK
        ; syscall
        ; pop rdi
        ; ret

;; State variables used
; STATE ( -- a-addr )
;  STATE @ is TRUE if compiling, FALSE otherwise
defvar "STATE", FTH_STATE
; HERE ( -- addr )
;  addr is the data-space pointer
defvar "HERE", FTH_HERE
; >IN ( -- a-addr )
;  >IN @ is the offset in characters from the start of the input buffer to parse area
defvar ">IN", FTH_INPUT_OFFSET, input_buffer            ; Pointer to the spot in the input buffer
; BASE ( -- a-addr )
;  BASE @ is the current number-conversion radix
defvar "BASE", FTH_BASE, 10
; Internal
%define last_defined_word 0x0 ; TODO
defvar "LATEST", FTH_LATEST, last_defined_word ; most recently defined word
defvar "S0", FTH_S0                            ; Initial stack ptr - for accessing args

;; Constants used
defconst "DOCOLON:", FTH_DOCOLON, DO_COLON
defconst "R0",       FTH_R0,      return_stack_top
defconst "FIMMED",   FTH_FIMMED,  F_IMMEDIATE
defconst "FHIDDEN",  FTH_FHIDDEN, F_HIDDEN
defconst "LENMASK",  FTH_LENMASK, F_LENMASK

;; Syscall values
%include "syscalls.nasm"
;; Stack operations
%include "stack-ops.nasm"
;; Arithmetic
%include "arithmetic.nasm"

;; Interpreter for colon definitions
        section .text
        align 8
DO_COLON:
        RSP_PUSH rsi
        add rax, 8
        mov rsi, rax
        NEXT

;; Program entry point
        section .text
        global _start
_start:
        cld ; Clear the DF flag
        
        ; S0 stores the original stack value (to access program args)
        mov [var_FTH_S0], rsp

        ; _COLD is the startup routine
        debugln "Calling COLD"
        jmp _COLD

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Necessary Words
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

; COLD ( -- )
; System startup
defcode "COLD", FTH_COLD
_COLD:
        mov rbp, return_stack_top
        mov QWORD [var_FTH_LATEST], last_defined_word
        mov rsi, FTH_QUIT
        NEXT

; FIFTH_LIT ( ?? )
; When compiled into a word, when that word executes FIFTH_LIT,
; the value of the following word is pushed onto the stack, skipping it.
; Used to compile numbers
defcode "FIFTH_LIT", FIFTH_LIT
        lodsq
        push rax
        NEXT

; FIFTH_RSP!
; Set the return stack pointer to a given value
defcode "FIFTH_RSP!", FIFTH_RSPSTORE
        pop rbp
        NEXT

;; KEY ( -- c )
;; receive one character c
defcode "KEY", FTH_KEY
        call _KEY
        push rax
        NEXT
_KEY:
        mov rbx, [key_currkey]
        cmp rbx, [key_bufftop]
        jge .refresh_input
        xor rax, rax
        mov al, [rbx] ; get next key from input buffer
        inc rbx
        mov [key_currkey], rbx ; increment key_currkey
        ret

.refresh_input:
        push rsi
        push rdi
        ; key_currkey = input_buffer
        mov QWORD [key_currkey], input_buffer
        ; read(STDIN_FILENO, input_buffer, INPUT_BUFFER_SIZE);
        mov rdi, STDIN_FILENO
        mov rsi, input_buffer
        mov rdx, INPUT_BUFFER_SIZE
        mov rax, SYS_READ
        syscall
        pop rdi
        pop rsi

        test rax, rax
        jbe .error
        mov rcx, input_buffer
        add rcx, rax
        mov [key_bufftop], rcx
        jmp _KEY

.error:
        debug "Error during call to read()"
        xor rdi, rdi
        mov rax, SYS_EXIT_GROUP
        syscall

        section .data
; Current place in input buffer
key_currkey: ; char *
        dq input_buffer
; Last valid data in input buffer
key_bufftop: ; char *
        dq input_buffer
        

;; WORD ( char "<chars>ccc<char>" -- c-addr )
;; Skips leading delimiters. Parses ccc delimited by char.
defcode "WORD", FTH_WORD
        call _WORD
        push rdi
        push rcx
        NEXT
;; Returns buffer in rdi, length in rcx
_WORD:
.start:
        call _KEY
        cmp al, '\'
        je .skip_comments
        cmp al, ' '
        jbe .start
        mov rdi, word_buffer

.word_loop:
        stosb ; Add character to return buffer
        call _KEY
        cmp al, ' '
        ja .word_loop

        sub rdi, word_buffer
        mov rcx, rdi
        mov rdi, word_buffer
        ret

.skip_comments:
        call _KEY
        cmp al, `\n`
        jne .skip_comments
        jmp .start

        section .bss
word_buffer:
        resb 32

; REFILL ( -- f )
defcode "REFILL", FTH_REFILL
        ; TODO
        NEXT

defcode "INTERPRET", FTH_INTERPRET
        ; TODO
        NEXT

defcode "BRANCH", FTH_BRANCH
        add rsi, [rsi]
        NEXT

defcode "0BRANCH", FTH_0BRANCH
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
        dq FIFTH_LIT, return_stack, FIFTH_RSPSTORE
        ; INTERPRET the code
        dq FTH_INTERPRET
        ; Loop forever
        dq FTH_BRANCH, -16

; MS ( u -- )
defcode "MS", FTH_MS
        pop rax
nanosleep:
        ; imul rax, 1000000
        push QWORD 999999999
        push QWORD 0
        ; nanosleep(&ts, NULL);
        mov rdi, rsp
        xor rsi, rsi
        mov rax, SYS_NANOSLEEP
        syscall
        add rsp, 16
        ret
        NEXT
