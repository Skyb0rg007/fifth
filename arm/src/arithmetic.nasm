;; vim: ft=nasm
%ifndef FIFTH_ARITHMETIC_NASM
%define FIFTH_ARITHMETIC_NASM

%include "macros.nasm"

;; Single-precision

; + ( n1 n2 -- n )
defcode "+", FTH_PLUS
        pop rax
        add QWORD [rsp], rax
        NEXT

; 1+ ( n1 -- n2 )
defcode "1+", FTH_INCR
        inc QWORD [rsp]
        NEXT

; - ( n1 n2 -- n )
defcode "-", FTH_MINUS
        pop rax
        sub QWORD [rsp], rax
        NEXT

; 1- ( n1 -- n2 )
defcode "1-", FTH_DECR
        dec QWORD [rsp]
        NEXT

; * ( n1 n2 -- n )
defcode "*", FTH_MULT
        pop rax
        pop rbx
        imul rax, rbx
        push rax
        NEXT

; / ( n1 n2 -- n )
defcode "/", FTH_DIV
        xor rdx, rdx
        pop rbx
        pop rax
        idiv rbx
        push rax
        NEXT

; MOD ( n1 n2 -- n )
defcode "MOD", FTH_MOD
        xor rdx, rdx
        pop rbx
        pop rax
        idiv rbx
        push rdx
        NEXT

; /MOD ( n1 n2 -- n )
defcode "/MOD", FTH_DIVMOD
        xor rdx, rdx
        pop rbx
        pop rax
        idiv rbx
        push rdx ; rem
        push rax ; div
        NEXT

; NEGATE ( n -- -n )
defcode "NEGATE", FTH_NEGATE
        neg QWORD [rsp]
        NEXT

; ABS ( n -- u )
; abs(x) = let y = x >>> 31 in (x ^ y) - y
defcode "ABS", FTH_ABS
        mov rax, [rsp]
        sar rax, 31
        xor [rsp], rax
        sub [rsp], rax
        NEXT

; MIN ( n1 n2 -- n )
defcode "MIN", FTH_MIN
        pop rax
        pop rbx
        cmp rax, rbx
        jae .1
        push rbx
        NEXT
.1:     push rax
        NEXT

; MAX ( n1 n2 -- n )
defcode "MAX", FTH_MAX
        pop rax
        pop rbx
        cmp rax, rbx
        jae .1
        push rax
        NEXT
.1:     push rbx
        NEXT

; AND ( x1 x2 -- x )
defcode "AND", FTH_AND
        pop rax
        and [rsp], rax
        NEXT

; OR ( x1 x2 -- x )
defcode "OR", FTH_OR
        pop rax
        or [rsp], rax
        NEXT

; XOR ( x1 x2 -- x )
defcode "XOR", FTH_XOR
        pop rax
        xor [rsp], rax
        NEXT

; INVERT ( x1 -- x2 )
defcode "INVERT", FTH_INVERT
        not QWORD [rsp]
        NEXT

; LSHIFT ( u1 n -- u2 )
defcode "LSHIFT", FTH_LSHIFT
        pop rcx
        shl QWORD [rsp], cl
        NEXT

; RSHIFT ( u1 n -- u2 )
defcode "RSHIFT", FTH_RSHIFT
        pop rcx
        shr QWORD [rsp], cl
        NEXT

; 2* ( x1 -- x2 )
defcode "2*", FTH_2MULT
        sar QWORD [rsp], 1
        NEXT

; 2/ ( x1 -- x2 )
defcode "2/", FTH_2DIV
        sal QWORD [rsp], 1
        NEXT

;; Comparisons
; TODO: confirm true+false values

; < ( n1 n2 -- f )
defcode "<", FTH_LT
        pop rax
        pop rbx
        cmp rax, rbx
        setl al
        movzx rax, al
        push rax
        NEXT

; <= ( n1 n2 -- f )
defcode "<=", FTH_LTE
        pop rax
        pop rbx
        cmp rax, rbx
        setle al
        movzx rax, al
        push rax
        NEXT

; <> ( n1 n2 -- f )
defcode "<>", FTH_NEQ
        pop rax
        pop rbx
        cmp rax, rbx
        setne al
        movzx rax, al
        push rax
        NEXT

; = ( n1 n2 -- f )
defcode "=", FTH_EQ
        pop rax
        pop rbx
        cmp rax, rbx
        sete al
        movzx rax, al
        push rax
        NEXT
        
; > ( n1 n2 -- f )
defcode ">", FTH_GT
        pop rax
        pop rbx
        cmp rax, rbx
        setg al
        movzx rax, al
        push rax
        NEXT

; >= ( n1 n2 -- f )
defcode ">=", FTH_GTE
        pop rax
        pop rbx
        cmp rax, rbx
        setge al
        movzx rax, al
        push rax
        NEXT

; 0< ( n -- f )
defcode "0<", FTH_LT0
        pop rax
        test rax, rax
        setl al
        movzx rax, al
        push rax
        NEXT

; 0<= ( n -- f )
defcode "0<=", FTH_LTE0
        pop rax
        test rax, rax
        setle al
        movzx rax, al
        push rax
        NEXT

; 0<> ( x -- f )
defcode "0<>", FTH_NEQ0
        pop rax
        test rax, rax
        setnz al
        movzx rax, al
        push rax
        NEXT

; 0= ( x -- f )
defcode "0=", FTH_EQ0
        pop rax
        test rax, rax
        setz al
        movzx rax, al
        push rax
        NEXT

; 0> ( n -- f )
defcode "0>", FTH_GT0
        pop rax
        test rax, rax
        setg al
        movzx rax, al
        push rax
        NEXT

; 0>= ( n -- f )
defcode "0>=", FTH_GTE0
        pop rax
        test rax, rax
        setge al
        movzx rax, al
        push rax
        NEXT

; U< ( u1 u2 -- f )
defcode "U<", FTH_ULT
        pop rax
        pop rbx
        cmp rax, rbx
        setb al
        movzx rax, al
        push rax
        NEXT

; U<= ( u1 u2 -- f )
defcode "U<=", FTH_ULTE
        pop rax
        pop rbx
        cmp rax, rbx
        setbe al
        movzx rax, al
        push rax
        NEXT

; U> ( u1 u2 -- f )
defcode "U>", FTH_UGT
        pop rax
        pop rbx
        cmp rax, rbx
        seta al
        movzx rax, al
        push rax
        NEXT

; U>= ( u1 u2 -- f )
defcode "U>=", FTH_UGTE
        pop rax
        pop rbx
        cmp rax, rbx
        setae al
        movzx rax, al
        push rax
        NEXT

; WITHIN - fifth implemented

%endif ; FIFTH_ARITHMETIC_NASM
