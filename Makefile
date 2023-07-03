# NASM = nasm
# NASMFLAGS = -felf64 -g
# LD = ld
# LDFLAGS =
# LDLIBS =

BUILDDIR  = _build
SOURCEDIR = src
MKDOCS    = mkdocs
# Also be sure to have MarkdownSuperscript installed

.DEFAULT: all
.PHONY: run clean docs docs-serve

all: fifth

run: $(BUILDDIR)/fifth
	@$(BUILDDIR)/fifth

clean:
	$(RM) -r $(BUILDDIR) ./site
	$(RM) fifth

docs:
	$(MKDOCS) build

docs-serve:
	$(MKDOCS) serve

fifth: $(BUILDDIR)/fifth

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
