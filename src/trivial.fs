\ vim: set ft=forth:

1 ARG 2CONSTANT outfilename
." Writing output to '" outfilename TYPE .\" '\n"
outfilename W/O BIN CREATE-FILE THROW CONSTANT outfile

S\" #!/bin/sh\necho Hello\n$(dirname $0)/.fifth\n" outfile WRITE-FILE THROW

outfile CLOSE-FILE THROW

BYE
