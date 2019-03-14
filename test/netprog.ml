
module M = struct
LOGGER EXTEND M
let f() =
LOG "%d" ~properties:[] 1 LEVEL NOTICE ;
()
end

module N = struct
LOGGER EXTEND N
let f() =
LOG "%d" ~properties:[] 1 LEVEL DEBUG ;
()

end

LOG "%d" ~properties:[] 1 LEVEL DEBUG ;;

M.f() ;;
N.f();;

Netlogger.Config.from_file "logcfg.json" ;;

M.f() ;;
N.f();;
