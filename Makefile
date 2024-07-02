# NASM = nasm
# NASMFLAGS = -felf64 -g
# LD = ld
# LDFLAGS =
# LDLIBS =

PREFIX  = /usr/local
DESTDIR =

BUILDDIR  = _build
SOURCEDIR = src
MKDOCS    = mkdocs
GFORTH    = gforth

# RISC-V stuff

.DEFAULT: all
.PHONY: clean install

all: fifth

fifth: $(BUILDDIR)/fifth $(BUILDDIR)/.fifth

clean:
	$(RM) $(BUILDDIR)/fifth
	$(RM) -d $(BUILDDIR)

install: $(BUILDDIR)/fifth
	install -d $(DESTDIR)$(PREFIX)/bin
	install -m 755 $(BUILDDIR)/fifth $(DESTDIR)$(PREFIX)/bin
	install -m 755 $(BUILDDIR)/.fifth $(DESTDIR)$(PREFIX)/bin

$(BUILDDIR):
	mkdir -p $(BUILDDIR)

$(BUILDDIR)/fifth $(BUILDDIR)/.fifth: src/trivial.fs | $(BUILDDIR)
	$(GFORTH) $< $@
	$(CC) -Wall -Wextra -std=c99 src/hello.c -o $(BUILDDIR)/.fifth

# Also be sure to have MarkdownSuperscript installed
# RV32_QEMU = qemu-system-riscv32
# RV32_RUN = riscv32-unknown-elf-run
# RV32_OBJDUMP = riscv32-unknown-elf-objdump
# RV32_GCC = riscv32-unknown-elf-gcc-13.2.0


# all: fifth

# run: $(BUILDDIR)/fifth
# 	@$(BUILDDIR)/fifth

# clean:
# 	$(RM) -r $(BUILDDIR) ./site
# 	$(RM) fifth

# docs:
# 	$(MKDOCS) build

# docs-serve:
# 	$(MKDOCS) serve

# fifth: $(BUILDDIR)/fifth

#############################################################################



# ASM_FILES := $(shell find $(SOURCEDIR) -name '*.nasm') $(BUILDDIR)/syscalls.nasm

# $(BUILDDIR)/fifth: $(BUILDDIR)/fifth.o | $(BUILDDIR)
# 	$(LD) $(LDFLAGS) $(LDLIBS) $^ -o $@

# $(BUILDDIR)/syscalls.nasm: $(UNISTD_HEADER) | $(BUILDDIR)
# 	@echo "Generating $@..."
# 	@$(RM) $@
# 	@>>$@ echo ";; vim: ft=nasm"
# 	@>>$@ echo
# 	@>>$@ echo ";; This file was generated - do not edit"
# 	@>>$@ echo
# 	@>>$@ echo "%ifndef FIFTH_SYSCALLS_NASM"
# 	@>>$@ echo "%define FIFTH_SYSCALLS_NASM"
# 	@>>$@ echo
# 	@>>$@ echo "%include \"macros.nasm\""
# 	@>>$@ echo
# 	@<$(UNISTD_HEADER) tr '[:lower:]' '[:upper:]' | sed -n 's/#DEFINE __NR_\([a-zA-Z_]\+\) \([0-9]\+\)/%define SYS_\1 \2\ndefconst "SYS_\1",FTH_SYS_\1,SYS_\1/p' >>$@
# 	@>>$@ echo
# 	@>>$@ echo "%endif ; FIFTH_SYSCALLS_NASM"
# 	@echo "Finished generating $@"

# $(BUILDDIR)/fifth.o: $(ASM_FILES) | $(BUILDDIR)
# 	$(NASM) $(NASMFLAGS) -i $(SOURCEDIR)/ -i $(BUILDDIR)/ $(SOURCEDIR)/fifth.nasm -o $@

# $(BUILDDIR):
# 	mkdir -p $@
