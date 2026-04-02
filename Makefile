SOLUTIONS := $(wildcard theories/*.v)
EXERCISES := $(addprefix exercises/,$(notdir $(SOLUTIONS)))

EXTRA_DIR:=coqdocjs/extra
COQDOCFLAGS:= \
  --toc --toc-depth 2 --html --interpolate \
  --index indexpage --no-lib-name --parse-comments \
  --with-header $(EXTRA_DIR)/header.html --with-footer $(EXTRA_DIR)/footer.html
export COQDOCFLAGS

all: Makefile.coq
	+make -f Makefile.coq all
.PHONY: all

clean: Makefile.coq
	+make -f Makefile.coq clean
	rm -f Makefile.coq
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

ALECTRYON_FLAGS := --webpage-style windowed
SEPVIZ_OUT_DIR := _sepviz_build
SEPVIZ_HTMLS   := $(SEPVIZ_OUT_DIR)/Iris-Queue.html $(SEPVIZ_OUT_DIR)/Iris-List.html

$(SEPVIZ_OUT_DIR):
	mkdir -p $@

$(SEPVIZ_OUT_DIR)/Iris-Queue.html: theories/queue.v
	alectryon $(ALECTRYON_FLAGS) --output $@ $<

$(SEPVIZ_OUT_DIR)/Iris-List.html: theories/linked_lists.v
	alectryon $(ALECTRYON_FLAGS) --output $@ $<

sepviz: $(SEPVIZ_HTMLS)

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
