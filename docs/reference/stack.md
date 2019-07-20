
### Primitive Data Stack Operations

| Name | Data Stack Change                | Notes |
| ---  | ---                              | ---   |
| DUP  | x -- x x                         |       |
| DROP | x --                             |       |
| SWAP | x^1^ x^2^ -- x^2^ x^1^           |       |
| OVER | x^1^ x^2^ -- x^1^ x^2^ x^1^      |       |
| ROT  | x^1^ x^2^ x^3^ -- x^2^ x^3^ x^1^ |       |
| -ROT | x^1^ x^2^ x^3^ -- x^3^ x^1^ x^2^ |       |
| NIP  | x^1^ x^2^ -- x^2^                |       |
| TUCK | x^1^ x^2^ -- x^2^ x^1^ x^2^      |       |
| ?DUP | x -- x x \| 0                    | Only duplicates x if x is nonzero |

### Double Data Stack Operations

| Name  | Data Stack Change                                              |
| ---   | ---                                                            |
| 2DUP  | x^1^ x^2^ -- x^1^ x^2^ x^1^ x^2^                               |
| 2DROP | x^1^ x^2^ --                                                   |
| 2SWAP | x^1^ x^2^ x^3^ x^4^ -- x^3^ x^4^ x^1^ x^2^                     |
| 2OVER | x^1^ x^2^ x^3^ x^4^ -- x^1^ x^2^ x^3^ x^4^ x^1^ x^2^           |
| 2ROT  | x^1^ x^2^ x^3^ x^4^ x^5^ x^6^ -- x^3^ x^4^ x^5^ x^6^ x^1^ x^2^ |
| 2NIP  | x^1^ x^2^ x^3^ x^4^ -- x^3^ x^4^                               |
| 2TUCK | x^1^ x^2^ x^3^ x^4^ -- x^3^ x^4^ x^1^ x^2^ x^3^ x^4^           |

### Return Stack Operations

| Name   | Data Stack Change | Return Stack Change    |
| ---    | ---               | ---                    |
| >R     | x --              | -- x                   |
| R>     | -- x              | x --                   |
| R@     | -- x              | x -- x                 |
| RDROP  | --                | x --                   |
| 2>R    | x^1^ x^2^ --      | -- x^1^ x^2^           |
| 2R>    | -- x^1^ x^2^      | x^1^ x^2^ --           |
| 2R@    | -- x^1^ x^2^      | x^1^ x^2^ -- x^1^ x^2^ |
| 2RDROP | --                | x^1^ x^2^ --           |

<!-- ### Floating Stack Operations

| Name  | Floating Stack Change            |
| ---   | ---                              |
| FDROP | r --                             |
| FNIP  | r^1^ r^2^ -- r^2^                |
| FDUP  | r -- r r                         |
| FOVER | r^1^ r^2^ -- r^1^ r^2^ r^1^      |
| FTUCK | r^1^ r^2^ -- r^2^ r^1^ r^2^      |
| FSWAP | r^1^ r^2^ -- r^2^ r^1^           |
| FROT  | r^1^ r^2^ r^3^ -- r^2^ r^3^ r^1^ | -->
