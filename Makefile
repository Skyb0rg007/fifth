NASM = nasm
NASMFLAGS = -felf64 -g
CC = gcc
LDFLAGS = -nostartfiles -nostdlib
LDLIBS =

BUILDDIR = _build

fifth: $(BUILDDIR)/fifth.o
	$(CC) $(LDFLAGS) $(LDLIBS) $^ -o $@

$(BUILDDIR)/fifth.o: fifth.nasm macros.nasm | $(BUILDDIR)
	$(NASM) $(NASMFLAGS) $< -o $@

$(BUILDDIR):
	mkdir -p $@
