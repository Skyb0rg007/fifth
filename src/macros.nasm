;; vim: ft=nasm

%ifndef FIFTH_MACROS_NASM
%define FIFTH_MACROS_NASM

;; Magic constants
%define STDIN_FILENO  0
%define STDOUT_FILENO 1
%define STDERR_FILENO 2

;; The FORTH inner-interpreter
%macro NEXT 0
        lodsq ; mov rax, [rsi] ; add rsi, 8
        jmp [rax]
%endmacro

;; Return stack macros
%macro RSP_PUSH 1
        lea rbp, [rbp - 8] ; sub rbp, 8
        mov [rbp], %1
%endmacro

%macro RSP_POP 1
        mov %1, [rbp]
        lea rbp, [rbp + 8] ; add rbp, 8
%endmacro


;;
;; Dictionary Macros
;;

;; Structure of HEADER + CODE
; ----------------------------
; | void *previous_word;     | 64 bits
; | int flags:2;             | 2 bits
; | int len:6;               | 6 bits
; | char name[?];            | <len> bits
; | char _padding[?];        | pad to 64 bit alignment
; ---------------------------
; | void *interpreter;       | 64 bits : asm code to jump to when calling the word
; | <additional data>        | 
; ---------------------------

; link starts at NULL; is redefined as words are added to the dictionary
%define link 0x0

;; Attributes
%define F_IMMEDIATE 10000000b
%define F_HIDDEN    01000000b
;; Mask to get the length from the flag+length field
%define F_LENMASK   00011111b

%macro defcode 2-3  0 ; name, label, flags=0
	%strlen namelen %1
        ; For an assembly-implemented word, the interpreter is a pointer to
        ; the assembly code
        ; The header is within .rodata, the assembly is .text (executable)

        ; HEADER
	section .rodata
	align 8
%%header:
	dq link               ; void *previous_word = link;
	%define link %%header ; link = current_word;
	db %3 + namelen       ; flags = flags; length = strlen(name);
	db %1                 ; name = name;
	align 8               ; pad to 64-bit alignment

        ; INTERPRETER
%2:
        ; jump to the implementation to run this word
	dq %%implementation

        ; IMPLEMENTATION
	section .text
%%implementation:
	; Write asm definition after this macro
        ; End the defintion with NEXT to 'return' from the assembly
%endmacro

%macro defword 2-3  0 ; name, label, flags=0
	%strlen namelen %1
        ; For a forth-implemented word, the interpreter is DO_COLON
        ; and the data is a list of the words to call
        ; Everything is .rodata since it isn't executed

        ; HEADER
	section .rodata
	align 8
%%header:
	dq link
	%define link %%header
	db %3 + namelen
	db %1
	align 8
        
        ; INTERPRETER
%2:
	dq DO_COLON ; The interpreter is DO_COLON
	; The following is lists of pointers to FORTH words
        ; Final word should be EXIT to 'return'
%endmacro

%macro defconst 3-4  0 ; name, label, value, flags=0
defcode %1, %2, %4
	push %3
	NEXT
%endmacro

%macro defvar 2-4  0 ; name, label, initial=0
; The function simply pushes the variable's address
defcode %1, %2, 0
	push var_%+%2
	NEXT

	section .data
	align 8
var_%+%2:
	dq %3
%endmacro




;; Debugging

%macro debug 1 ; string to print
        %strlen string_len %1
        ; Store the string in .rodata
        [SECTION .rodata]
%%string:
        db %1
        __SECT__
        ; Save all the registers
        push rdi
        push rsi
        push rdx
        push rax
        push rbx
        push rcx
        ; write(STDERR_FILENO, string, string_len+1);
        mov rdi, STDERR_FILENO
        mov rsi, %%string
        mov rdx, string_len
        mov rax, SYS_WRITE
        syscall
        ; Restore registers
        pop rcx
        pop rbx
        pop rax
        pop rdx
        pop rsi
        pop rdi
%endmacro

%macro debugln 1
        debug %1
        debug `\n`
%endmacro

%macro debug_char 1 ; char to print
        ; Save all the registers
        push rdi
        push rsi
        push rdx
        push rax
        push rbx
        push rcx
        
        push QWORD %1
        ; write(STDERR_FILENO, string, string_len+1);
        mov rdi, STDERR_FILENO
        mov rsi, rsp
        mov rdx, 1
        mov rax, SYS_WRITE
        syscall
        pop rax

        ; Restore registers
        pop rcx
        pop rbx
        pop rax
        pop rdx
        pop rsi
        pop rdi
%endmacro

%macro debug_int 1
        ; Save all the registers
        push rdi
        push rsi
        push rdx
        push rax
        push rbx
        push rcx
        
        mov rax, %1 ; Number to print

        mov rcx, 10 ; Number of characters to print
%%push_loop: 
        mov rbx, 10
        xor rdx, rdx ; rdx needs to be 0 to call idiv
        idiv rbx ; rax := num / 10, rdx := num % 10
        add rdx, '0'
        push rdx
        dec rcx
        jnz %%push_loop

        mov rcx, 10
%%print_loop:
        pop rax
        debug_char rax
        dec rcx
        jnz %%print_loop

        ; Restore registers
        pop rcx
        pop rbx
        pop rax
        pop rdx
        pop rsi
        pop rdi
%endmacro

%macro exit 1 ; exit code
        ; exit(code);
        mov rdi, %1
        mov rax, SYS_EXIT_GROUP ; note: SYS_EXIT only exits current thread
        syscall
        ; If unsuccessful, segfault
        hlt
%endmacro

%endif ; FIFTH_MACROS_NASM
