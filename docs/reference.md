
* , ( x -- ) reserve + store
* @ ( addr -- x ) get
* >in ( -- a-addr ) input buffer offset
* dup ( x -- x x )
* base ( -- a-addr )
* word ( char "<chars>ccc<char>" -- c-addr )
* abort ( i*x -- ) ( R: j*x -- ) empty stack + call QUIT
* 0branch (  )
* interpret (  )
* + ( n1 n2 -- n )
* ! ( x a-addr -- )
* lit (  )
* swap ( x1 x2 -- x2 x1 )
* last (  )
* find ( c-addr -- c-addr 0 | xt 1 | xt -1 )
* create ( "<spaces>name" -- ) -> name ( -- a-addr )
* constant ( x "<spaces>name" -- ) -> name ( -- x )
* (;code) (  )
* = ( x1 x2 -- f )
* ; (  )
* tib (  )
* drop ( x -- )
* emit ( c -- )
* state ( -- a-addr )
* accept ( c-addr +n1 -- +n2 )
* >number ( ud1 c-addr1 u1 -- ud2 c-addr2 u2 )
* : ( )
* dp 
* rot (  )
* #tib
* exit ( -- ) ( R: nest-sys -- )
* count ( c-addr1 -- c-addr2 u )
* execute ( i*x xt -- j*x )
