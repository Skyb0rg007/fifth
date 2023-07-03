;; vim: ft=nasm
%ifndef FIFTH_STACK_OPS_NASM
%define FIFTH_STACK_OPS_NASM

%include "macros.nasm"
;; Single Stack Operations

; DUP ( x -- x x )
defcode "DUP", FTH_DUP
        mov rax, [rsp]
        push rax
        NEXT

; DROP ( x -- )
defcode "DROP", FTH_DROP
        pop rax
        NEXT

; SWAP ( x1 x2 -- x2 x1 )
defcode "SWAP", FTH_SWAP
        pop rax
        pop rbx
        push rax
        push rbx
        NEXT

; OVER ( x1 x2 -- x1 x2 x1 )
defcode "OVER", FTH_OVER
        mov rax, [rsp + 8]
        push rax
        NEXT

; ROT ( x1 x2 x3 -- x2 x3 x1 )
defcode "ROT", FTH_ROT
	pop rax
	pop rbx
	pop rcx
	push rbx
	push rax
	push rcx
	NEXT

; -ROT ( x1 x2 x3 -- x3 x1 x2 )
defcode "-ROT", FTH_NROT
	pop rax
	pop rbx
	pop rcx
	push rax
	push rcx
	push rbx
	NEXT

; NIP ( x1 x2 -- x2 )
defcode "NIP", FTH_NIP
        pop rax
        pop rbx
        push rax
        NEXT

; TUCK ( x1 x2 -- x2 x1 x2 )
defcode "TUCK", FTH_TUCK
        pop rax
        pop rbx
        push rax
        push rbx
        push rax
        NEXT

; ?DUP ( x -- x x | 0 )
defcode "?DUP", FTH_QDUP
        mov rax, [rsp]
        test rax, rax
        jz .1
        push rax
.1:     NEXT

;; Double stack operations

; 2DUP ( d -- d d )
defcode "2DUP", FTH_2DUP
        mov rax, [rsp]
        mov rbx, [rsp + 8]
        push rbx
        push rax
        NEXT

; 2DROP ( d -- )
defcode "2DROP", FTH_2DROP
        pop rax
        pop rax
        NEXT

; 2SWAP ( d1 d2 -- d2 d1 )
defcode "2SWAP", FTH_2SWAP
        pop rax
        pop rbx
        pop rcx
        pop rdx
        push rbx
        push rax
        push rdx
        push rcx
        NEXT

; 2OVER ( d1 d2 -- d1 d2 d1 )
defcode "2OVER", FTH_2OVER
        mov rax, [rsp + 16]
        mov rbx, [rsp + 24]
        push rbx
        push rax
        NEXT

; 2ROT ( d1 d2 d3 -- d2 d3 d1 )
defcode "2ROT", FTH_2ROT
        pop rax
        pop rbx
        pop rcx
        pop rdx
        pop r8
        pop r9
        push rdx
        push rcx
        push r9
        push r8
        push rbx
        push rax
        NEXT

; 2NIP ( d1 d2 -- d2 )
defcode "2NIP", FTH_2NIP
        pop rax
        pop rbx
        pop rcx
        pop rcx
        push rbx
        push rax
        NEXT
        
; 2TUCK ( d1 d2 -- d2 d1 d2 )
defcode "2TUCK", FTH_2TUCK
        pop rax
        pop rbx
        pop rcx
        pop rdx
        push rbx
        push rax
        push rdx
        push rcx
        push rbx
        push rax
        NEXT

;; Return Stack

; >R ( x -- ) R: ( -- x )
defcode ">R", FTH_TOR
        pop rax
        RSP_PUSH rax
        NEXT

; R> ( -- x ) R: ( x -- )
defcode "R>", FTH_FROMR
        RSP_POP rax
        push rax
        NEXT

; R@ ( -- x ) R: ( x -- x )
defcode "R@", FTH_RFETCH
        push QWORD [rbp]
        NEXT

; RDROP ( -- ) R: ( x -- )
defcode "RDROP", FTH_RDROP
        lea rbp, [rbp + 8]
        NEXT

; 2>R ( d -- ) R: ( -- d )
defcode "2>R", FTH_2TOR
        pop rax
        pop rbx
        RSP_PUSH rbx
        RSP_PUSH rax
        NEXT

; 2R> ( -- d ) R: ( d -- )
defcode "2R>", FTH_2FROMR
        RSP_POP rax
        RSP_POP rbx
        push rbx
        push rax
        NEXT

; 2R@ ( -- d ) R: ( d -- d )
defcode "2R@", FTH_2RFETCH
        push QWORD [rbp + 8]
        push QWORD [rbp]
        NEXT

; 2RDROP ( -- ) R: ( d -- )
defcode "2RDROP", FTH_2RDROP
        lea rbp, [rbp + 16]
        NEXT

%endif
