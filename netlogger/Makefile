NAME = netlogging

PACKAGES=ppx_deriving_yojson,ppx_sexp_conv,pcre,yojson,ppx_deriving.show,netstring,netsys

all:
	ocamlfind ocamlc -package $(PACKAGES) -c netlogger.mli
	ocamlfind ocamlc -package $(PACKAGES) -c netlogger.ml
	ocamlfind ocamlc -a -package $(PACKAGES) -o $(NAME).cma netlogger.cmo
	ocamlfind ocamlopt -package $(PACKAGES) -c netlogger.ml
	ocamlfind ocamlopt -a -package $(PACKAGES) -o $(NAME).cmxa netlogger.cmx

clean:
	rm -f *.ppo *.ppr *.o *.ast *~ *.ml.html *.annot *.cm*
