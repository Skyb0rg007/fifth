
### Primitive Data Stack Operations

| Name | Data Stack Change                                                                      | Notes                             |
| ---  | ---                                                                                    | ---                               |
| DUP  | x -- x x                                                                               |                                   |
| DROP | x --                                                                                   |                                   |
| SWAP | x<sup>1</sup> x<sup>2</sup> -- x<sup>2</sup> x<sup>1</sup>                             |                                   |
| OVER | x<sup>1</sup> x<sup>2</sup> -- x<sup>1</sup> x<sup>2</sup> x<sup>1</sup>               |                                   |
| ROT  | x<sup>1</sup> x<sup>2</sup> x<sup>3</sup> -- x<sup>2</sup> x<sup>3</sup> x<sup>1</sup> |                                   |
| -ROT | x<sup>1</sup> x<sup>2</sup> x<sup>3</sup> -- x<sup>3</sup> x<sup>1</sup> x<sup>2</sup> |                                   |
| NIP  | x<sup>1</sup> x<sup>2</sup> -- x<sup>2</sup>                                           |                                   |
| TUCK | x<sup>1</sup> x<sup>2</sup> -- x<sup>2</sup> x<sup>1</sup> x<sup>2</sup>               |                                   |
| ?DUP | x -- x x \| 0                                                                          | Only duplicates x if x is nonzero |

### Double Data Stack Operations

| Name  | Data Stack Change                                                                                                                                                          |
| ---   | ---                                                                                                                                                                        |
| 2DUP  | x<sup>1</sup> x<sup>2</sup> -- x<sup>1</sup> x<sup>2</sup> x<sup>1</sup> x<sup>2</sup>                                                                                     |
| 2DROP | x<sup>1</sup> x<sup>2</sup> --                                                                                                                                             |
| 2SWAP | x<sup>1</sup> x<sup>2</sup> x<sup>3</sup> x<sup>4</sup> -- x<sup>3</sup> x<sup>4</sup> x<sup>1</sup> x<sup>2</sup>                                                         |
| 2OVER | x<sup>1</sup> x<sup>2</sup> x<sup>3</sup> x<sup>4</sup> -- x<sup>1</sup> x<sup>2</sup> x<sup>3</sup> x<sup>4</sup> x<sup>1</sup> x<sup>2</sup>                             |
| 2ROT  | x<sup>1</sup> x<sup>2</sup> x<sup>3</sup> x<sup>4</sup> x<sup>5</sup> x<sup>6</sup> -- x<sup>3</sup> x<sup>4</sup> x<sup>5</sup> x<sup>6</sup> x<sup>1</sup> x<sup>2</sup> |
| 2NIP  | x<sup>1</sup> x<sup>2</sup> x<sup>3</sup> x<sup>4</sup> -- x<sup>3</sup> x<sup>4</sup>                                                                                     |
| 2TUCK | x<sup>1</sup> x<sup>2</sup> x<sup>3</sup> x<sup>4</sup> -- x<sup>3</sup> x<sup>4</sup> x<sup>1</sup> x<sup>2</sup> x<sup>3</sup> x<sup>4</sup>                             |

### Return Stack Operations

| Name   | Data Stack Change              | Return Stack Change                                        |
| ---    | ---                            | ---                                                        |
| >R     | x --                           | -- x                                                       |
| R>     | -- x                           | x --                                                       |
| R@     | -- x                           | x -- x                                                     |
| RDROP  | --                             | x --                                                       |
| 2>R    | x<sup>1</sup> x<sup>2</sup> -- | -- x<sup>1</sup> x<sup>2</sup>                             |
| 2R>    | -- x<sup>1</sup> x<sup>2</sup> | x<sup>1</sup> x<sup>2</sup> --                             |
| 2R@    | -- x<sup>1</sup> x<sup>2</sup> | x<sup>1</sup> x<sup>2</sup> -- x<sup>1</sup> x<sup>2</sup> |
| 2RDROP | --                             | x<sup>1</sup> x<sup>2</sup> --                             |

### Floating Stack Operations

| Name  | Floating Stack Change                                                                  |
| ---   | ---                                                                                    |
| FDROP | r --                                                                                   |
| FNIP  | r<sup>1</sup> r<sup>2</sup> -- r<sup>2</sup>                                           |
| FDUP  | r -- r r                                                                               |
| FOVER | r<sup>1</sup> r<sup>2</sup> -- r<sup>1</sup> r<sup>2</sup> r<sup>1</sup>               |
| FTUCK | r<sup>1</sup> r<sup>2</sup> -- r<sup>2</sup> r<sup>1</sup> r<sup>2</sup>               |
| FSWAP | r<sup>1</sup> r<sup>2</sup> -- r<sup>2</sup> r<sup>1</sup>                             |
| FROT  | r<sup>1</sup> r<sup>2</sup> r<sup>3</sup> -- r<sup>2</sup> r<sup>3</sup> r<sup>1</sup> |
