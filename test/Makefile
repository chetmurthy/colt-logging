PA_GENERIC_LOGARGS=-ppopt -logger -ppopt MODULE -ppopt -level -ppopt LEVEL

PACKAGES=camlp5,colt-logging

all: baseprog_DEBUG baseprog_TRACE netprog_DEBUG netprog_TRACE

PA_BASE_LOGARGS=$(PA_GENERIC_LOGARGS:MODULE=Logging)
PA_BASE_DEBUG_LOGARGS=$(PA_BASE_LOGARGS:LEVEL=DEBUG)
PA_BASE_TRACE_LOGARGS=$(PA_BASE_LOGARGS:LEVEL=TRACE)

baseprog_DEBUG: baseprog.ml
	OCAMLFIND_CONF=../.site-lib/findlib.conf ocamlfind ocamlc \
	-package $(PACKAGES),colt-logging.baselogging -syntax camlp5o -syntax colt \
	$(PA_BASE_DEBUG_LOGARGS) \
	-linkall -linkpkg -o baseprog_DEBUG baseprog.ml

baseprog_TRACE: baseprog.ml
	OCAMLFIND_CONF=../.site-lib/findlib.conf ocamlfind ocamlc \
	-package $(PACKAGES),colt-logging.baselogging -syntax camlp5o -syntax colt \
	$(PA_BASE_TRACE_LOGARGS) \
	-linkall -linkpkg -o baseprog_TRACE baseprog.ml

PA_NET_LOGARGS=$(PA_GENERIC_LOGARGS:MODULE=Netlogger)
PA_NET_DEBUG_LOGARGS=$(PA_NET_LOGARGS:LEVEL=DEBUG)
PA_NET_TRACE_LOGARGS=$(PA_NET_LOGARGS:LEVEL=TRACE)

netprog_DEBUG: netprog.ml
	OCAMLFIND_CONF=../.site-lib/findlib.conf ocamlfind ocamlc \
	-package $(PACKAGES),colt-logging.netlogging -syntax camlp5o -syntax colt \
	$(PA_NET_DEBUG_LOGARGS) \
	-linkall -linkpkg -o netprog_DEBUG netprog.ml

netprog_TRACE: netprog.ml
	OCAMLFIND_CONF=../.site-lib/findlib.conf ocamlfind ocamlc \
	-package $(PACKAGES),colt-logging.netlogging -syntax camlp5o -syntax colt \
	$(PA_NET_TRACE_LOGARGS) \
	-linkall -linkpkg -o netprog_TRACE netprog.ml

clean:
	rm -f *.ppo *.ppr *.cm* *.o *.ast *~ *.ml.html *.annot *prog *prog_DEBUG *prog_TRACE
