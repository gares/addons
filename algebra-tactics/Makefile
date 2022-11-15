REPO = https://github.com/proux01/algebra-tactics.git
TAG = hierarchy-builder
WORKDIR = workdir

.PHONY: all get prepare

all: $(WORKDIR) prepare
	make -C $(WORKDIR)
	rm -rf ../_build/$(CONTEXT)/algebra-tactics/ && cp -r . ../_build/$(CONTEXT)/algebra-tactics/
	(cd ../_build/$(CONTEXT)/algebra-tactics; npx jscoq build --workspace algebra-tactics.json)

prepare: $(WORKDIR)

get: $(WORKDIR)

$(WORKDIR):
	git clone --depth=1 -b $(TAG) $(REPO) $(WORKDIR)

clean:
	make -C $(WORKDIR) clean
	rm -f $(WORKDIR)/Makefile.coq{,.conf}

install:
	make -C $(WORKDIR) install