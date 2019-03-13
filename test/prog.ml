
module M = struct
LOGGER EXTEND M
let f() =
LOG "%d" ~properties:[] 1 LEVEL INFO0 ;
()
end

module N = struct
LOGGER EXTEND N
let f() =
LOG "%d" ~properties:[] 1 LEVEL TRACE9 ;
()

end

LOG "%d" ~properties:[] 1 LEVEL DEBUG9 ;;

M.f() ;;
N.f();;

Logging.Config.from_file "logcfg.json" ;;

M.f() ;;
N.f();;
