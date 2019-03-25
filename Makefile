PROJECT=colt-logging

OCAMLFIND=ocamlfind

SYNTAX_FILES = syntax/pa_colt.cmo 
BASELOGGER_FILES = baselogger/baselogging.cma baselogger/baselogging.cmxa baselogger/logging.cmi
NETLOGGER_FILES = netlogger/netlogging.cma netlogger/netlogging.cmxa netlogger/netlogger.cmi
INSTALL_COMMAND=$(OCAMLFIND) install colt-logging META $(SYNTAX_FILES) $(BASELOGGER_FILES) $(NETLOGGER_FILES)

WD=$(shell pwd)

all::
	make -C syntax all
	make -C baselogger all
	make -C netlogger all
	rm -rf .site-lib && mkdir .site-lib
	OCAMLFIND_DESTDIR=$(WD)/.site-lib $(INSTALL_COMMAND)
	make -C test all


install:: all
	$(OCAMLFIND) query $(PROJECT) && $(OCAMLFIND) remove $(PROJECT) || true;
	$(INSTALL_COMMAND)

clean::
	make -C syntax clean
	make -C baselogger clean
	make -C netlogger clean
	make -C test clean
	rm -rf .site-lib

uninstall::
	$(OCAMLFIND) query $(PROJECT) && $(OCAMLFIND) remove $(PROJECT) || true;
