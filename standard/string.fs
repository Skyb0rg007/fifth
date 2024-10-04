\ vim: set ft=forth:

\ WORDLIST CONSTANT forth:string
\ GET-CURRENT ALSO forth:string SET-CURRENT DEFINITIONS

WORDLIST CONSTANT wid-subst
S" /COUNTED-STRING" ENVIRONMENT? 0= [IF] 256 [THEN]
CHARS CONSTANT string-max

: place ( c-addr1 u c-addr2 -- )
    \ Copy the string c-addr1 u as a counted string to address c-addr2
    2DUP 2>R             \ c-addr1 u c-addr2 R: u c-addr2
    1 CHARS + SWAP MOVE  \ R: u c-addr2
    2R> C!
;

: make-subst ( c-addr u -- c-addr )
    \ Create a substitution and storage space
    \ Returns the address of the buffer for substitution text
    GET-CURRENT >R wid-subst SET-CURRENT
    ['] CREATE EXECUTE-PARSING
    R> SET-CURRENT
    HERE string-max ALLOT 0 OVER C!
;

: find-subst ( c-addr u -- xt flag | 0 )
    \ Given a name, find the substitution
    \ Returns xt flag if found, or 0 otherwise
    wid-subst SEARCH-WORDLIST
;

: bounds ( c-addr u -- c-addr+u c-addr )
    OVER + SWAP
;

CHAR % CONSTANT delim

string-max BUFFER: Name
VARIABLE DestLen
2VARIABLE Dest
VARIABLE SubstErr

: addDest ( char -- )
    Dest @ DestLen @ < IF
        Dest 2@ + C! 1 CHARS Dest +!
    ELSE
        DROP -1 SubstErr !
    THEN
;

: formName ( c-addr u -- c-addr' u' )
    1 /STRING 2DUP delim scan >R DROP
    2DUP R> - DUP >R Name place
    R> 1 CHARS + /STRING
;

: >dest ( c-addr len -- )
    bounds ?DO
        I C@ addDest
    1 CHARS +LOOP
;

: processName ( -- flag )
    Name COUNT find-subst DUP >R IF
        EXECUTE COUNT >dest
    ELSE
        delim addDest Name COUNT >dest delim addDest
    THEN
    R>
;

\ SET-CURRENT

: REPLACES ( c-addr1 u1 c-addr2 u2 -- )
    2DUP find-subst IF
        NIP NIP EXECUTE
    ELSE
        make-subst
    THEN
    place
;

: SUBSTITUTE ( c-addr1 -- )
    Destlen ! 0 Dest 2! 0 -rot \ -- 0 src slen
       0 SubstErr !
       BEGIN
         DUP 0 >
       WHILE
         OVER C@ delim <> IF	               \ character not %
           OVER C@ addDest 1 /STRING
         ELSE
           OVER 1 CHARS + C@ delim = IF	   \ %% for one output %
             delim addDest 2 /STRING	      \ add one % to output
           ELSE
             formName processName IF
               ROT 1+ -rot                    \ count substitutions
             THEN
           THEN
         THEN
       REPEAT
       2DROP Dest 2@ ROT SubstErr @ IF
         DROP SubstErr @
       THEN
;

\ PREVIOUS
