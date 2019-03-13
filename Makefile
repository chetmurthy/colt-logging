PROJECT=colt-logging

OCAMLFIND=ocamlfind

SYNTAX_FILES = syntax/pa_colt.cmo 
BASELOGGER_FILES = baselogger/baselogging.cma baselogger/logging.cmi

all::
	make -C syntax all
	make -C baselogger all
	rm -rf .site-lib && mkdir .site-lib
	$(OCAMLFIND) install -destdir .site-lib colt-logging META $(SYNTAX_FILES) $(BASELOGGER_FILES)

install:: all
	$(OCAMLFIND) query $(PROJECT) && $(OCAMLFIND) remove $(PROJECT) || true;
	$(OCAMLFIND) install colt-logging META $(SYNTAX_FILES) $(BASELOGGER_FILES)

clean::
	make -C syntax clean
	make -C baselogger clean
	rm -rf .site-lib

uninstall::
	$(OCAMLFIND) query $(PROJECT) && $(OCAMLFIND) remove $(PROJECT) || true;
