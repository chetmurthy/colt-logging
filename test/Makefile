PA_LOGARGS=-logger "Logging" -level DEBUG

PACKAGES=camlp5,colt-logging,colt-logging.baselogging

all:
	OCAMLFIND_CONF=../.site-lib/findlib.conf ocamlfind ocamlc -package $(PACKAGES) -syntax camlp5o -syntax syntax -c prog.ml
	OCAMLFIND_CONF=../.site-lib/findlib.conf ocamlfind ocamlc -package $(PACKAGES) -linkpkg -linkall -o prog prog.cmo

clean:
	rm -f prog *.ppo *.ppr *.cmo *.cmi *.o *.cmx *.ast *~ *.ml.html *.annot
