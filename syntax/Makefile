NAME = colt

PACKAGES=camlp5,camlp5.quotations,camlp5.gramlib,camlp5.extend

all:
	ocamlfind ocamlc -c -package $(PACKAGES) -syntax camlp5o -dtypes pa_$(NAME).ml

clean:
	rm -f *.ppo *.ppr *.cmo *.cmi *.o *.cmx *.ast *~ *.ml.html *.annot
