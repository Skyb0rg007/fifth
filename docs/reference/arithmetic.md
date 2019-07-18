### Notation

* n - signed integer
* u - unsigned integer
* x - arbitrary cell

### Single-Precision Arithmetic

These operations act on signed integers

| Name   | Data Stack Change                                          |
| ---    | ---                                                        |
| +      | n<sup>1</sup> n<sup>2</sup> -- n                           |
| 1+     | n<sup>1</sup> -- n<sup>2</sup>                             |
| UNDER+ | n<sup>1</sup> x n<sup>2</sup> -- n x                       |
| -      | n<sup>1</sup> n<sup>2</sup> -- n                           |
| 1-     | n -- n                                                     |
| *      | n<sup>1</sup> n<sup>2</sup> -- n                           |
| /      | n<sup>1</sup> n<sup>2</sup> -- n                           |
| MOD    | n<sup>1</sup> n<sup>2</sup> -- n                           |
| /MOD   | n<sup>1</sup> n<sup>2</sup> -- n<sup>3</sup> n<sup>4</sup> |
| NEGATE | n -- n                                                     |
| ABS    | n -- u                                                     |
| MIN    | n<sup>1</sup> n<sup>2</sup> -- n                           |
| MAX    | n<sup>1</sup> n<sup>2</sup> -- n                           |

### Bitwise Arithmetic

| Name   | Data Stack Change                | Notes                       |
| ------ | -----------------                |                             |
| AND    | x<sup>1</sup> x<sup>2</sup> -- x |                             |
| OR     | x<sup>1</sup> x<sup>2</sup> -- x |                             |
| XOR    | x<sup>1</sup> x<sup>2</sup> -- x |                             |
| INVERT | x<sup>1</sup> -- x<sup>2</sup>   |                             |
| LSHIFT | u<sup>1</sup> n -- u<sup>2</sup> |                             |
| RSHIFT | u<sup>1</sup> n -- u<sup>2</sup> | Logical right shift         |
| 2*     | x<sup>1</sup> -- x<sup>2</sup>   | Shift left by 1             |
| 2/     | x<sup>1</sup> -- x<sup>2</sup>   | Arithmetic shift right by 1 |

### Numeric Comparison

| Name   | Data Stack Change                              | Notes                                                                                                                               |
| ------ | -----------------                              |                                                                                                                                     |
| <      | n<sup>1</sup> n<sup>2</sup> -- f               |                                                                                                                                     |
| <=     | n<sup>1</sup> n<sup>2</sup> -- f               |                                                                                                                                     |
| <      | n<sup>1</sup> n<sup>2</sup> -- f               |                                                                                                                                     |
| <=     | n<sup>1</sup> n<sup>2</sup> -- f               |                                                                                                                                     |
| <>     | n<sup>1</sup> n<sup>2</sup> -- f               |                                                                                                                                     |
| =      | n<sup>1</sup> n<sup>2</sup> -- f               |                                                                                                                                     |
| >      | n<sup>1</sup> n<sup>2</sup> -- f               |                                                                                                                                     |
| >=     | n<sup>1</sup> n<sup>2</sup> -- f               |                                                                                                                                     |
| 0<     | n -- f                                         |                                                                                                                                     |
| 0<=    | n -- f                                         |                                                                                                                                     |
| 0<>    | n -- f                                         |                                                                                                                                     |
| 0=     | n -- f                                         |                                                                                                                                     |
| 0>     | n -- f                                         |                                                                                                                                     |
| 0>=    | n -- f                                         |                                                                                                                                     |
| u<     | u<sup>1</sup> u<sup>2</sup> -- f               |                                                                                                                                     |
| u<=    | u<sup>1</sup> u<sup>2</sup> -- f               |                                                                                                                                     |
| u>     | u<sup>1</sup> u<sup>2</sup> -- f               |                                                                                                                                     |
| u>=    | u<sup>1</sup> u<sup>2</sup> -- f               |                                                                                                                                     |
| within | u<sup>1</sup> u<sup>2</sup> u<sup>3</sup> -- f | u<sup>1</sup> ∈ [u<sup>2</sup>,u<sup>3</sup>) or, if u<sup>3</sup> ≤ u<sup>2</sup>, u<sup>1</sup> ∉ [u<sup>3</sup>, u<sup>2</sup>) |

### Floating Arithmetic

# TODO

| Name      | Data Stack Change | Floating Stack Change                        | Notes                                               |
| ---       | ---               | ---                                          |                                                     |
| F+        | --                | r<sup>1</sup> r<sup>2</sup> -- r<sup>3</sup> |                                                     |
| F-        | --                | r<sup>1</sup> r<sup>2</sup> -- r<sup>3</sup> |                                                     |
| F*        | --                | r<sup>1</sup> r<sup>2</sup> -- r<sup>3</sup> |                                                     |
| F/        | --                | r<sup>1</sup> r<sup>2</sup> -- r<sup>3</sup> |                                                     |
| FNEGATE   | --                | r<sup>1</sup> -- r<sup>2</sup>               |                                                     |
| FABS      | --                | r<sup>1</sup> -- r<sup>2</sup>               |                                                     |
| FMAX      | --                | r<sup>1</sup> r<sup>2</sup> -- r<sup>3</sup> |                                                     |
| FMIN      | --                | r<sup>1</sup> r<sup>2</sup> -- r<sup>3</sup> |                                                     |
| FLOOR     | --                | r<sup>1</sup> -- r<sup>2</sup>               | Rounds towards -∞                                   |
| FROUND    | --                | r<sup>1</sup> -- r<sup>2</sup>               | Rounds to nearest integral                          |
| F**       | --                | r<sup>1</sup> r<sup>2</sup> -- r<sup>3</sup> | raise r<sup>1</sup> to the r<sup>2</sup>th power    |
| FSQRT     | --                | r<sup>1</sup> -- r<sup>2</sup>               |                                                     |
| FEXP      | --                | r<sup>1</sup> -- r<sup>2</sup>               |                                                     |
| FEXPM1    | --                | r<sup>1</sup> -- r<sup>2</sup>               | r<sup>2</sup> = e<sup>r<sup>1</sup></sup>-1         |
| FLN       | --                | r<sup>1</sup> -- r<sup>2</sup>               | log<sub>e</sub>(r<sup>1</sup>)                      |
| FLNP1     | --                | r<sup>1</sup> -- r<sup>2</sup>               | r<sup>2</sup> = log<sub>e</sub>(r<sup>1</sup> + 1)  |
| FLOG      | --                | r<sup>1</sup> -- r<sup>2</sup>               | r<sup>2</sup> = log<sub>10</sub>(r<sup>1</sup>)     |
| FALOG     | --                | r<sup>1</sup> -- r<sup>2</sup>               | r<sup>2</sup> = 10<sup>r<sup>1</sup></sup>          |
| F2*       | --                | r<sup>1</sup> -- r<sup>2</sup>               | r<sup>2</sup> = r<sup>1</sup> * 2.0                 |
| F2/       | --                | r<sup>1</sup> -- r<sup>2</sup>               | r<sup>2</sup> = r<sup>1</sup> * 0.5                 |
| 1/F       | --                | r<sup>1</sup> -- r<sup>2</sup>               | r<sup>2</sup> = 1.0 / r<sup>1</sup>                 |
| PRECISION | -- u              | --                                           | The number of significant digits used by F. FE. FS. |

