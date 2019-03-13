PA_LOGARGS=-ppopt -logger -ppopt "Logging" -ppopt -level -ppopt LEVEL

PACKAGES=camlp5,colt-logging,colt-logging.baselogging

all: prog

prog: prog.cmo
	OCAMLFIND_CONF=../.site-lib/findlib.conf ocamlfind  ocamlc -package $(PACKAGES) -linkpkg -linkall -o prog prog.cmo

prog.cmo: prog.ml
	OCAMLFIND_CONF=../.site-lib/findlib.conf ocamlfind ocamlc -verbose -package $(PACKAGES) -syntax camlp5o -syntax colt $(PA_LOGARGS:LEVEL=DEBUG) -c prog.ml

prog.ppo: prog.ml
	camlp5 -nolib '-I' '/home/chet/Hack/Ocaml/4.07.1-HACKING/ocaml-base-compiler.4.07.1/lib/camlp5' '-I' '/home/chet/Hack/Ocaml-Hacking/src/colt-logging/.site-lib/colt-logging' 'pa_o.cmo' 'pa_op.cmo' pr_o.cmo 'pr_op.cmo' 'pa_colt.cmo' '-logger' 'Logging' '-level' 'DEBUG' prog.ml > prog.ppo

clean:
	rm -f prog *.ppo *.ppr *.cm* *.o *.ast *~ *.ml.html *.annot
