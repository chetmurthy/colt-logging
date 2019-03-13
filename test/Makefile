PA_LOGARGS=-ppopt -logger -ppopt "Logging" -ppopt -level -ppopt LEVEL

PACKAGES=camlp5,colt-logging,colt-logging

all: baseprog_DEBUG baseprog_TRACE

baseprog_DEBUG: baseprog.ml
	OCAMLFIND_CONF=../.site-lib/findlib.conf ocamlfind ocamlc \
	-package $(PACKAGES).baselogging -syntax camlp5o -syntax colt \
	$(PA_LOGARGS:LEVEL=DEBUG) \
	-linkall -linkpkg -o baseprog_DEBUG baseprog.ml

baseprog_TRACE: baseprog.ml
	OCAMLFIND_CONF=../.site-lib/findlib.conf ocamlfind ocamlc \
	-package $(PACKAGES).baselogging -syntax camlp5o -syntax colt \
	$(PA_LOGARGS:LEVEL=TRACE) \
	-linkall -linkpkg -o baseprog_TRACE baseprog.ml

clean:
	rm -f *.ppo *.ppr *.cm* *.o *.ast *~ *.ml.html *.annot baseprog baseprog_DEBUG baseprog_TRACE
