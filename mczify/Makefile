REPO = https://github.com/proux01/mczify.git
TAG = hierarchy-builder
WORKDIR = workdir

.PHONY: all get prepare

all: $(WORKDIR) prepare
	make -C $(WORKDIR) build
	rm -rf ../_build/$(CONTEXT)/mczify/ && cp -r . ../_build/$(CONTEXT)/mczify/
	(cd ../_build/$(CONTEXT)/mczify; npx jscoq build --workspace mczify.json)

prepare: $(WORKDIR)

get: $(WORKDIR)

$(WORKDIR):
	git clone --depth=1 -b $(TAG) $(REPO) $(WORKDIR)

clean:
	make -C $(WORKDIR) clean
	rm -f $(WORKDIR)/Makefile.coq{,.conf}

install:
	make -C $(WORKDIR) install