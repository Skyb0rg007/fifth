### Notation

* n - signed integer
* u - unsigned integer
* x - arbitrary cell

### Single-Precision Arithmetic

These operations act on signed integers

| Name   | Data Stack Change      | Notes                                |
| ---    | ---                    | ---                                  |
| +      | n^1^ n^2^ -- n         |                                      |
| 1+     | n^1^ -- n^2^           |                                      |
| -      | n^1^ n^2^ -- n         |                                      |
| 1-     | n -- n                 |                                      |
| *      | n^1^ n^2^ -- n         |                                      |
| /      | n^1^ n^2^ -- n         |                                      |
| MOD    | n^1^ n^2^ -- n         |                                      |
| /MOD   | n^1^ n^2^ -- n^3^ n^4^ | n^3^ = n^1^ / n^2^; n^4^ = remainder |
| NEGATE | n -- n                 |                                      |
| ABS    | n -- u                 |                                      |
| MIN    | n^1^ n^2^ -- n         |                                      |
| MAX    | n^1^ n^2^ -- n         |                                      |

### Bitwise Arithmetic

| Name   | Data Stack Change | Notes                       |
| ------ | ----------------- |                             |
| AND    | x^1^ x^2^ -- x    |                             |
| OR     | x^1^ x^2^ -- x    |                             |
| XOR    | x^1^ x^2^ -- x    |                             |
| INVERT | x^1^ -- x^2^      |                             |
| LSHIFT | u^1^ n -- u^2^    |                             |
| RSHIFT | u^1^ n -- u^2^    | Logical right shift         |
| 2*     | x^1^ -- x^2^      | Shift left by 1             |
| 2/     | x^1^ -- x^2^      | Arithmetic shift right by 1 |

### Numeric Comparison

| Name   | Data Stack Change   | Notes                                                      |
| ------ | -----------------   |                                                            |
| <      | n^1^ n^2^ -- f      |                                                            |
| <=     | n^1^ n^2^ -- f      |                                                            |
| <>     | n^1^ n^2^ -- f      |                                                            |
| =      | n^1^ n^2^ -- f      |                                                            |
| >      | n^1^ n^2^ -- f      |                                                            |
| >=     | n^1^ n^2^ -- f      |                                                            |
| 0<     | n -- f              |                                                            |
| 0<=    | n -- f              |                                                            |
| 0<>    | n -- f              |                                                            |
| 0=     | n -- f              |                                                            |
| 0>     | n -- f              |                                                            |
| 0>=    | n -- f              |                                                            |
| U<     | u^1^ u^2^ -- f      |                                                            |
| U<=    | u^1^ u^2^ -- f      |                                                            |
| U>     | u^1^ u^2^ -- f      |                                                            |
| U>=    | u^1^ u^2^ -- f      |                                                            |
| WITHIN | u^1^ u^2^ u^3^ -- f | u^1^ ∈ [u^2^,u^3^) or, if u^3^ ≤ u^2^, u^1^ ∉ [u^3^, u^2^) |

<!-- ### Floating Arithmetic

#### TODO: finish

| Name      | Data Stack Change | Floating Stack Change | Notes                                               |
| ---       | ---               | ---                   |                                                     |
| F+        | --                | r^1^ r^2^ -- r^3^     |                                                     |
| F-        | --                | r^1^ r^2^ -- r^3^     |                                                     |
| F*        | --                | r^1^ r^2^ -- r^3^     |                                                     |
| F/        | --                | r^1^ r^2^ -- r^3^     |                                                     |
| FNEGATE   | --                | r^1^ -- r^2^          |                                                     |
| FABS      | --                | r^1^ -- r^2^          |                                                     |
| FMAX      | --                | r^1^ r^2^ -- r^3^     |                                                     |
| FMIN      | --                | r^1^ r^2^ -- r^3^     |                                                     |
| FLOOR     | --                | r^1^ -- r^2^          | Rounds towards -∞                                   |
| FROUND    | --                | r^1^ -- r^2^          | Rounds to nearest integral                          |
| F**       | --                | r^1^ r^2^ -- r^3^     | raise r^1^ to the r^2^th power                      |
| FSQRT     | --                | r^1^ -- r^2^          |                                                     |
| FEXP      | --                | r^1^ -- r^2^          |                                                     |
| FEXPM1    | --                | r^1^ -- r^2^          | e^r<sup>1</sup>^-1                                  |
| FLN       | --                | r^1^ -- r^2^          | log<sub>e</sub>(r^1^)                               |
| FLNP1     | --                | r^1^ -- r^2^          | log<sub>e</sub>(r^1^ + 1)                           |
| FLOG      | --                | r^1^ -- r^2^          | log<sub>10</sub>(r^1^)                              |
| FALOG     | --                | r^1^ -- r^2^          | 10^r<sup>1</sup>^                                   |
| F2*       | --                | r^1^ -- r^2^          | r^1^ * 2.0                                          |
| F2/       | --                | r^1^ -- r^2^          | r^1^ * 0.5                                          |
| 1/F       | --                | r^1^ -- r^2^          | 1.0 / r^1^                                          |
| PRECISION | -- u              | --                    | The number of significant digits used by F. FE. FS. |
 -->
