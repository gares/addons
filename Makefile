PKGS = elpi mathcomp hierarchy-builder mczify algebra-tactics

CONTEXT = wacoq
ifeq ($(DUNE_WORKSPACE:%.64=64), 64)
CONTEXT = jscoq+64bit
endif
ifeq ($(DUNE_WORKSPACE:%.wacoq=wacoq), wacoq)
CONTEXT = wacoq
endif
export CONTEXT

# needed when invoking `opam install`
OPAMSWITCH = $(CONTEXT)
export OPAMSWITCH

ifeq ($(DUNE_WORKSPACE),)
ifeq ($(CONTEXT), wacoq)
DUNE_WORKSPACE = $(PWD)/dune-workspace.wacoq
endif
ifeq ($(CONTEXT), jscoq+64bit)
DUNE_WORKSPACE = $(PWD)/dune-workspace.64
endif
endif

ifneq ($(DUNE_WORKSPACE),)
export DUNE_WORKSPACE
endif

OPAM_ENV = eval `opam env`

BUILT_PKGS = ${filter $(PKGS), ${notdir ${wildcard _build/$(CONTEXT)/*}}}

_V = ${firstword $(VERSION) $(VER) $(V)}

COMMIT_FLAGS = -a

ifneq ($(_V),)
MSG = [deploy] Prepare for $(_V).
else
ifeq ($(CONTEXT), wacoq)
_V = 0.15.0
else
_V = ${shell jscoq --version}
endif
MSG = ${error MSG= is mandatory}
endif

elpi:
	cd elpi               && make && make install

hierarchy-builder:
	cd hierarchy-builder  && make && make install

mathcomp:
	cd mathcomp           && make && make install

mczify:
	cd mczify    && make && make install

algebra-tactics:
	cd algebra-tactics    && make && make install


.PHONY: elpi hierarchy-builder mathcomp algebra-tactics mczify

env:
	@echo export DUNE_WORKSPACE=$(DUNE_WORKSPACE)

set-ver:
	_scripts/set-ver ${addprefix @,$(CONTEXT)} $(_V)
	if [ -e _build/$(CONTEXT) ] ; then \
	  $(OPAM_ENV) && dune build _build/$(CONTEXT)/*/package.json ; fi  # update build directory as well

pack:
	rm -rf _build/$(CONTEXT)/*.tgz
	_scripts/set-ver ${addprefix @,$(CONTEXT)} $(_V) _build/$(CONTEXT)
	cd _build/$(CONTEXT) && npm pack ${addprefix ./, $(BUILT_PKGS)}

commit-all:
	for d in $(PKGS); do ( cd $$d && git commit $(COMMIT_FLAGS) -m "$(MSG)" ); done
	git commit $(COMMIT_FLAGS) -m "$(MSG)"

push-all:
	for d in $(PKGS); do ( cd $$d && git push $(PUSH_FLAGS) ); done

commit+push-all:
	for d in $(PKGS); do ( cd $$d && \
	   	git commit $(COMMIT_FLAGS) -m "$(MSG)" && \
	    git push $(PUSH_FLAGS) ); done
	git commit $(COMMIT_FLAGS) -m "$(MSG)" && git push $(PUSH_FLAGS)

clean-slate:
	rm -rf */workdir
	rm -rf _build

ci:
	$(MAKE) clean-slate
	$(OPAM_ENV) && $(MAKE)
	$(MAKE) pack
