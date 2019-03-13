NAME = logging

PACKAGES=ppx_deriving_yojson,ppx_sexp_conv,pcre,yojson,ppx_deriving.show,netstring

PALOGARGS=-logger "Logging" -level DEBUG

all:
	ocamlfind ocamlc -package $(PACKAGES) -c logging.ml
	ocamlfind ocamlc -a -package $(PACKAGES) -linkall -linkpkg -o baselogger.cma logging.ml

clean:
	rm -f prog *.ppo *.ppr *.cmo *.cmi *.o *.cmx *.ast *~ *.ml.html *.annot *.cm*
