;; vim: ft=nasm

%include "macros.nasm"

%define STDIN_FILENO  0
%define STDOUT_FILENO 1
%define STDERR_FILENO 2

%define __NR_read       0
%define __NR_write      1
%define __NR_exit_group 231

;; Assembler entry point
        section .text
        global _start
_start:
        cld ; Clears the DF flag

        ; Initialization
        mov rbp, return_stack
        mov rsp, data_stack
        mov rsi, cold_start
        NEXT

;; FORTH word entry point
        section .rodata
cold_start:
        dq FORTH_QUIT

;; The Code Field for colon definitions
        section .text
        align 8
DOCOLON:
        PUSHRSP rsi
        add rax, 8      ; rax contains [rsi] from previous NEXT call
        mov rsi, rax
        NEXT

;; rax = misc
;; rbx = misc
;; rcx = misc
;; rdx = misc
;; rsi = next word to execute
;; rsp = data stack
;; rbp = return stack
;; r8-15 = misc

;; Data

        section .bss
data_stack:
        resb 1000
data_stack_len equ $ - data_stack

return_stack:
        resb 1000
return_stack_len equ $ - return_stack

;;     Entry
;; +-------------+
;; | Link        |  Pointer to previous definition (qword)
;; | Flags | Len |  Flags and string length (byte: 3bits | 5bits)
;; | String      |  String storage + qword alignment (variable length)
;; | Code Field  |  The word's "interpreter" (qword)
;; | Parameters  |  Parameters to "the interpreter" (variable length)
;; +-------------+

;; defcode name, label, flags=0
;; ...asm...
;; Add a word to the dictionary defined by asm

;; defword name, label, flags=0
;; dq FORTH_*
;; Adds a word to the dictionary defined by FORTH words

;; defconst name, label, value, flags=0
;; Adds a word with CONSTANT semantics

;; defvar name, label, initial=0, flags=0
;; Adds a word with VARIABLE semantics

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; Dictionary Start:
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;
;; Necessary Variables
;;

        ;; STATE ( -- a-addr ) core
        defvar "STATE", FORTH_STATE, 0
        ;; >IN ( -- a-addr ) core
        defvar ">IN", FORTH_INOFFSET, 0
        ;; BASE ( -- a-addr ) core
        defvar "BASE", FORTH_BASE, 10
        ;; HERE ( -- a-addr ) core
        defvar "HERE", FORTH_HERE, 0

        ;; LATEST ( -- a-addr ) fifth
        defvar "LATEST", FORTH_LATEST, 0 ;TODO
        ; ;; #TIB ( -- a-addr ) fifth
        ; defvar "#TIB", FORTH_NUMTIB
        ; ;; TIB ( -- a-addr ) fifth
        ; defvar "TIB", FORTH_TIB

;;
;; Data Stack Manipulation
;;
;; These are implemented in assembly for performance reasons
        
        ;; DROP ( w -- ) core
        defcode "DROP", FORTH_DROP
        pop rax
        NEXT

        ;; SWAP ( w1 w2 -- w2 w1 ) core
        defcode "SWAP", FORTH_SWAP
        pop rax
        pop rbx
        push rax
        push rbx
        NEXT

        ;; DUP ( w -- w w ) core
        defcode "DUP", FORTH_DUP
        mov rax, [rsp]
        push rax
        NEXT

        ;; OVER ( w1 w2 -- w1 w2 w1 ) core
        defcode "OVER", FORTH_OVER
        mov rax, [rsp + 8]
        push rax
        NEXT

        ;; ROT ( w1 w2 w3 -- w2 w3 w1 ) core
        defcode "ROT", FORTH_ROT
        pop rax
        pop rbx
        pop rcx
        push rbx
        push rcx
        push rax
        NEXT

        ;; 2DROP ( w1 w2 -- ) core
        defcode "2DROP", FORTH_2DROP
        pop rax
        pop rax
        NEXT

        ;; 2DUP ( w1 w2 -- w1 w2 w1 w2 ) core
        defcode "2DUP", FORTH_2DUP
        mov rax, [rsp]
        mov rbx, [rsp + 8]
        push rbx
        push rax
        NEXT

        ;; 2SWAP ( w1 w2 w3 w4 -- w3 w4 w1 w2 ) core
        defcode "2SWAP", FORTH_2SWAP
        pop rax
        pop rbx
        pop rcx
        pop rdx
        push rbx
        push rax
        push rdx
        push rcx
        NEXT

        ;; ?DUP ( x -- 0 | x x ) core
        defcode "?DUP", FORTH_QDUP
        mov rax, [rsp]
        test rax, rax
        jz .next
        push rax
.next:  NEXT

        ;; ROLL ( wu wu-1 ... w0 u -- wu-1 ... w0 wu ) core-ext
        ; TODO

        ;; PICK ( wu ... w1 w0 u -- wu .. w1 w0 wu ) core-ext
        defword "PICK", FORTH_PICK
        pop rax ; u
        mov rbx, [rsp + 8 * rax] ; rbx = wu
        push rbx
        NEXT

        ;; NIP ( w1 w2 -- w2 ) core-ext
        defword "NIP", FORTH_NIP
        pop rax
        pop rbx
        push rax
        NEXT

        ;; TUCK ( w1 w2 -- w2 w1 w2 ) core-ext
        defword "TUCK", FORTH_TUCK
        pop rax
        pop rbx
        push rax
        push rbx
        push rax
        NEXT

;;
;; Return Stack Manipulation
;;
;; These are implemented here for performance reasons

        ;; >R ( w -- ) ( R: -- w ) core
        defcode ">R", FORTH_TOR
        pop rax
        PUSHRSP rax
        NEXT

        ;; R> ( -- w ) ( R: w -- ) core
        defcode "R>", FORTH_FROMR
        POPRSP rax
        push rax
        NEXT

        ;; R@ ( -- w ) ( R: w -- w ) core
        defcode "R@", FORTH_RSPFETCH
        mov rax, [rbp]
        push rax
        NEXT

        ;; 2>R ( w1 w2 -- ) ( R: -- w1 w2 ) core-ext
        defcode "2>R", FORTH_2TOR
        pop rax
        pop rbx
        PUSHRSP rbx
        PUSHRSP rax
        NEXT

        ;; 2R> ( -- w1 w2 ) ( R: w1 w2 -- ) core-ext
        defcode "2R>", FORTH_2FROMR
        POPRSP rax
        POPRSP rbx
        push rbx
        push rax
        NEXT

        ;; 2R@ ( -- w1 w2 ) ( R: w1 w2 -- w1 w2 ) core-ext
        defcode "2R@", FORTH_2RSPFETCH
        mov rax, [rbp]
        mov rbx, [rbp + 8]
        push rbx
        push rax
        NEXT

        ;; RSP! ( x -- ) ( R: ?? -- ?? ) fifth
        defcode "RSP!", FORTH_RSPSTORE
        pop rbp
        NEXT

;;
;; Arithmetic
;;
;; These are implemented here for performance reasons
        
        ;; + ( n1 n2 -- n3 ) core
        defcode "+", FORTH_PLUS
        pop rax
        add [rsp], rax
        NEXT

        ;; AND ( n1 n2 -- n3 ) core
        defcode "AND", FORTH_AND
        pop rax
        and [rsp], rax
        NEXT

        ;; INVERT ( n1 -- n2 ) core
        defcode "INVERT", FORTH_INVERT
        not qword [rsp]
        NEXT

;;
;; Memory Access
;;
;; These are implemented here for performance reasons

        ;; ! ( x a-addr -- ) core
        defcode "!", FORTH_STORE
        pop rax ; a-addr
        pop rbx ; x
        mov [rax], rbx
        NEXT

        ;; @ ( a-addr -- x ) core
        defcode "@", FORTH_FETCH
        pop rax ; a-addr
        push qword [rax]
        NEXT

        ;; +! ( n a-addr -- ) core
        defcode "+!", FORTH_ADDSTORE
        pop rax
        pop rbx
        add [rbx], rax
        NEXT

        ;; C! ( x a-addr -- ) core
        defcode "C!", FORTH_STOREBYTE
        pop rax ; x
        pop rbx ; a-addr
        mov [rbx], bl
        NEXT

        ;; C@ ( a-addr -- c ) core
        defcode "C@", FORTH_FETCHBYTE
        pop rax ; a-addr
        xor rbx, rbx
        mov bl, [rax]
        push rbx
        NEXT

        ;; 2! ( w1 w2 a-addr -- ) core
        defcode "2!", FORTH_2STORE
        pop rax ; a-addr
        pop rbx ; w2
        mov [rax], rbx
        pop rbx ; w1
        mov [rax + 8], rbx
        NEXT

        ;; 2@ ( a-addr -- w1 w2 ) core
        defcode "2@", FORTH_2FETCH
        pop rax
        push qword [rax + 8]
        push qword [rax]
        NEXT

;;
;; Miscellaneous Necessary Primitives
;;
        ;; EXECUTE ( i*x xt -- j*x ) core
        defcode "EXECUTE", FORTH_EXECUTE
        pop rax
        jmp [rax]

        ;; ABORT ( i*x -- ) ( R: j*x -- )
        defcode "ABORT", FORTH_ABORT
        mov qword [var_FORTH_STATE], 0
        mov rsp, data_stack
        mov rbp, return_stack
        mov rsi, cold_start
        NEXT

        ;; , ( x -- )
        defcode ",", FORTH_COMMA
        pop rax
        mov rdi, [var_FORTH_HERE]
        stosq
        mov [var_FORTH_HERE], rdi
        NEXT

        ;; LIT ( -- n ) fifth
        defcode "LIT", FORTH_LIT
        lodsq ; Load the next instruction. Treat it as a literal number
        push rax ; Push that literal number
        NEXT

        ;; EXIT ( -- ) core
        defcode "EXIT", FORTH_EXIT
        POPRSP rsi
        NEXT

        ;; COUNT ( c-addr1 -- c-addr2 u ) core
        defcode "COUNT", FORTH_COUNT
        mov rax, [rsp]
        inc qword [rsp]
        push rax
        NEXT

        ;; ACCEPT ( c-addr +n1 -- +n2 ) core
        defcode "ACCEPT", FORTH_ACCEPT
        mov r10, rsi
        mov r9, rdi
        mov rdi, STDIN_FILENO   ; int fd
        pop rdx                 ; int len = u
        pop rsi                 ; char *buf = c-addr
        mov rax, __NR_read      ; read()
        syscall
        push rax        ; Number of bytes read
        mov rdi, r10
        mov rdi, r9
        NEXT
        
        ;; >NUMBER ( ud1 c-addr1 u1 -- ud2 c-addr2 u2 ) core
        defcode ">NUMBER", FORTH_TONUMBER
        ; TODO
        NEXT

        ;; FIND ( ) core

        ;; (;code) fifth
        defcode "(;CODE)", FORTH_DO_SEMI_CODE
        mov rdi, [var_FORTH_LATEST]
        mov al, [rdi + 4]

        ;; INTERPRET
        defword "INTERPRET", FORTH_INTERPRET

        ;; QUIT ( -- ) ( R: i*x -- ) core
        defword "QUIT", FORTH_QUIT
        ; $return_stack RSP!
        dq FORTH_LIT, return_stack, FORTH_RSPSTORE
        ; INTERPRET
        dq FORTH_INTERPRET
        ; loop forever
        dq FORTH_BRANCH, -16

;;
;; Control Flow
;;

        ;; BRANCH ( -- ) fifth
        defcode "BRANCH", FORTH_BRANCH
        add rsi, [rsi] ; Add the offset to rsi
        NEXT

        ;; 0BRANCH ( f -- ) fifth
        defcode "0BRANCH", FORTH_0BRANCH
        pop rax ; flag
        test rax, rax
        jz code_FORTH_BRANCH ; Acts like 'BRANCH' on zero
        lodsq ; Otherwise skip the offset
        NEXT

;;
;;
;;

;;
;; I/O
;;

        ;; EMIT ( c -- ) core
        defcode "EMIT", FORTH_EMIT
        mov r10, rsi ; Save rsi and rdi before the syscall
        mov r9, rdi  ;
        pop rax                 ; place c into emit_scratch
        mov [emit_scratch], rax ;
        mov rdi, STDOUT_FILENO  ; int fd
        mov rsi, emit_scratch   ; char *buf
        mov rdx, 1              ; int len
        mov rax, __NR_write     ; write()
        syscall
        mov rsi, r10
        mov rdi, r9
        NEXT

        section .bss
emit_scratch:
        resb 1

        ;; TYPE ( c-addr u -- ) core
        defcode "TYPE", FORTH_TYPE
        mov r10, rsi
        mov r9, rdi
        mov rdi, STDOUT_FILENO  ; int fd
        pop rdx                 ; int len = u
        pop rsi                 ; char *buf = c-addr
        mov rax, __NR_write     ; write()
        syscall
        mov rdi, r10
        mov rdi, r9
        NEXT

;;
;;
;;


        ;; NUMBER
        defcode "NUMBER", FORTH_NUMBER

