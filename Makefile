NASM = nasm
NASMFLAGS = -felf64 -g
LD = ld
LDFLAGS =
LDLIBS =

BUILDDIR  = _build
SOURCEDIR = src
MKDOCS    = mkdocs  # Ensure at least 1.0.4 (from pip, not ex. dnf)

.DEFAULT: all
.PHONY: run clean docs docs-serve

all: fifth

run: $(BUILDDIR)/fifth
	$(BUILDDIR)/fifth

clean:
	$(RM) $(BUILDDIR)/*.o $(BUILDDIR)/fifth

docs:
	$(MKDOCS) build

docs-serve:
	$(MKDOCS) serve

fifth: $(BUILDDIR)/fifth

#############################################################################

$(BUILDDIR)/fifth: $(BUILDDIR)/fifth.o
	$(LD) $(LDFLAGS) $(LDLIBS) $^ -o $@

$(BUILDDIR)/fifth.o: $(SOURCEDIR)/fifth.nasm | $(BUILDDIR)
	$(NASM) $(NASMFLAGS) -i ./$(SOURCEDIR)/ $< -o $@

$(BUILDDIR):
	mkdir -p $@
