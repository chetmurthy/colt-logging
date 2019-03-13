PA_LOGARGS=-ppopt -logger -ppopt "Logging" -ppopt -level -ppopt LEVEL

PACKAGES=camlp5,colt-logging,colt-logging.baselogging

all: prog_DEBUG prog_TRACE

prog_DEBUG: prog.ml
	OCAMLFIND_CONF=../.site-lib/findlib.conf ocamlfind ocamlc -verbose -package $(PACKAGES) -syntax camlp5o -syntax colt $(PA_LOGARGS:LEVEL=DEBUG) -linkall -linkpkg -o prog_DEBUG prog.ml

prog_TRACE: prog.ml
	OCAMLFIND_CONF=../.site-lib/findlib.conf ocamlfind ocamlc -verbose -package $(PACKAGES) -syntax camlp5o -syntax colt $(PA_LOGARGS:LEVEL=TRACE) -linkall -linkpkg -o prog_TRACE prog.ml

clean:
	rm -f *.ppo *.ppr *.cm* *.o *.ast *~ *.ml.html *.annot prog prog_DEBUG prog_TRACE
