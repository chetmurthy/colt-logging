NAME = baselogging

PACKAGES=ppx_deriving_yojson,ppx_sexp_conv,pcre,yojson,ppx_deriving.show,netstring

all:
	ocamlfind ocamlc -package $(PACKAGES) -c logging.mli
	ocamlfind ocamlc -package $(PACKAGES) -c logging.ml
	ocamlfind ocamlc -a -package $(PACKAGES) -o $(NAME).cma logging.ml

clean:
	rm -f *.ppo *.ppr *.o *.ast *~ *.ml.html *.annot *.cm*
