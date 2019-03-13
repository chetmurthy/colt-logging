NAME = colt

PACKAGES=ppx_deriving_yojson,ppx_sexp_conv,pcre,yojson,ppx_deriving.show

all:
	camlp5o pa_extend.cmo q_MLast.cmo pr_o.cmo pr_ro.cmo pa_$(NAME).ml \
		-o pa_$(NAME).ppo -loc loc
	camlp5o pa_extend.cmo q_MLast.cmo pa_$(NAME).ml \
		-o pa_$(NAME).ast -loc loc
	ocamlc -c -I +camlp5 -pp 'camlp5o pa_extend.cmo q_MLast.cmo -loc loc' \
		-dtypes pa_$(NAME).ml

clean:
	rm -f *.ppo *.ppr *.cmo *.cmi *.o *.cmx *.ast *~ *.ml.html *.annot
