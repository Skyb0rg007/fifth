;; vim: ft=nasm

;; The FORTH inner-interpreter
%macro NEXT 0
        lodsq ; mov rax, [rsi] ; add rsi, 8
        jmp [rax]
%endmacro

;; Return stack macros
%macro PUSHRSP 1
        lea rbp, [rbp - 8] ; sub rbp, 8
        mov [rbp], %1
%endmacro

%macro POPRSP 1
        mov %1, [rbp]
        lea rbp, [rbp + 8] ; add rbp, 8
%endmacro



;; Dictionary Macros

; Starts at NULL, is redefined as words are added to the dictionary
%define link 0x0

;; Attributes
%define F_IMMEDIATE 10000000b
%define F_HIDDEN    01000000b
;; Get the length from the length field
%define F_LENMASK   00011111b

%macro defcode 2-3  0 ; name, label, flags=0
	; This data is written in the rodata section since it's constant
	section .rodata
	align 8

	%strlen namelen %1

name_%+%2:
	dq link ; Pointer to previous word
	%define link %[name_%+%2]
	db %3 + namelen ; Flags + name length
	db %1 ; Name itself

	align 8 ; Padding to qword
%2:
	dq code_%+%2

	; This is where the implementing code goes
	section .text
code_%+%2:
	; Write asm definition after this macro, followed by NEXT
%endmacro

;; Define a FORTH word built from other FORTH words
%macro defword 2-3  0 ; name, label, flags=0

	section .rodata
	align 8

	%strlen namelen %1

name_%+%2:
	dq link
	%define link %[name_%+%2]
	db %3 + namelen
	db %1

	align 8
%2:
	dq DOCOLON ; The codeword (interpreter)
	; Write FORTH words after this, ending with 'EXIT'
%endmacro

%macro defconst 3-4  0 ; name, label, value, flags=0
defcode %1, %2, %4
	push %3
	NEXT
%endmacro

%macro defvar 2-4  0, 0 ; name, label, initial=0, flags=0
; The function simply pushes the variable's address
defcode %1, %2, %4
	push var_%+%2
	NEXT

	section .data
	align 8
var_%+%2:
	dq %3
%endmacro
