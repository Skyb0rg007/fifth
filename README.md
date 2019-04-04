# Fifth

Jonesforth-based FORTH interpreter for x86_64 Linux


## Goals

#### Parts of the [FORTH 2012 Standard](forth-standard.org/standard/words)

* Core + Core Ext
* Double + Double Ext
* Facility + Facility Ext
* File + File Ext
* Extended-Char + Extended-Char Ext
* String + String Ext
* Search + Search Ext
* Exception + Exception Ext
* Tools + Tools Ext
    - FORGET is not implemented

Locals, memory, block are not implemented


## Kernel

* Stack operation words
    - DUP, NIP, SWAP, R>, >R, etc. are implemented in assembly
    - These words are really simple, and easier than in FORTH
* Arithmetic words
    - +, -, 1+, 2*, etc.
    - Easy to implement in assembly
* BRANCH, BRANCH0
    - Primitives for control-flow
* EXIT
* LITERAL, LIT
    - Adding numbers to definitions
* Memory access words
    - !, @, +!, etc.
    - Easy to implement in assembly
* SOURCE, SOURCE-ID, >IN, PARSE, WORD
    - Interpreter/Input parsin
* NUMBER, BASE
    - number conversion
* COMMA, CREATE, LATEST, HIDDEN, IMMEDIATE, COLON
    - basic needs
* FORTH-WORDLIST, GET-CURRENT, SET-CURRENT
    - wordlist primitives
