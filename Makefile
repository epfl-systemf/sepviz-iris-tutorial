SOLUTIONS := $(wildcard theories/*.v)
EXERCISES := $(addprefix exercises/,$(notdir $(SOLUTIONS)))

EXTRA_DIR:=coqdocjs/extra
COQDOCFLAGS:= \
  --toc --toc-depth 2 --html --interpolate \
  --index indexpage --no-lib-name --parse-comments \
  --with-header $(EXTRA_DIR)/header.html --with-footer $(EXTRA_DIR)/footer.html
export COQDOCFLAGS

COQ_FLAGS := -Q theories solutions -Q exercises exercises

all: Makefile.coq
	+make -f Makefile.coq all
	+make sepviz
.PHONY: all

clean: Makefile.coq
	+make -f Makefile.coq clean
	rm -f Makefile.coq
	+make clean-sepviz
.PHONY: clean

html: Makefile.coq _CoqProject
	rm -fr html
	+make -f Makefile.coq $@
	cp -R $(EXTRA_DIR)/resources html
.PHONY: html

Makefile.coq: _CoqProject
	coq_makefile -f _CoqProject -o Makefile.coq

exercises: $(EXERCISES)
.PHONY: exercises sepviz


# sepviz

ALECTRYON_FLAGS := \
  $(COQ_FLAGS) \
  --webpage-style windowed \
  --long-line-threshold 0

SEPVIZ_OUTDIR  := _sepviz_build
SEPVIZ_MODULES := queue
SEPVIZ_HTMLS   := $(patsubst %,$(SEPVIZ_OUTDIR)/Iris-%.html,$(SEPVIZ_MODULES))

$(SEPVIZ_OUTDIR):
	mkdir -p $@

$(SEPVIZ_OUTDIR)/Iris-%.html: theories/%.v
	alectryon $(ALECTRYON_FLAGS) --output $@ $<

sepviz: $(SEPVIZ_HTMLS)
.PHONY: sepviz

clean-sepviz:
	rm -rf $(SEPVIZ_OUTDIR)
.PHONY: clean-sepviz

$(EXERCISES): exercises/%.v: theories/%.v gen-exercises.awk
	@if test -f $@ && ! git diff --exit-code $@ >/dev/null; then \
	  echo "Exercise file $@ has been changed; skipping exercise generation"; \
	else \
	  echo "Generating exercise file $@ from $<"; \
	  gawk -f gen-exercises.awk < $< > $@; \
	fi

ci: all
	+@make -B exercises # force make (in case exercise files have been edited directly)
	if [ -n "$$(git status --porcelain)" ]; then echo 'ERROR: Exercise files are not up-to-date with solutions. `git diff` and `git status` after re-making them:'; git diff; git status; exit 1; fi
.PHONY: ci
