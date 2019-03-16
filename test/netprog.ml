
module M = struct
LOGGER EXTEND M
let f() =
LOG "%d" ~properties:[] 1 LEVEL NOTICE ;
()
end

module N = struct
LOGGER EXTEND N
let f() =
LOG "%d" ~properties:[] 2 LEVEL DEBUG ;
()

end

LOG "%d" ~properties:[] 3 LEVEL DEBUG ;;

M.f() ;;
N.f();;

Netlogger.Config.from_file "netlog-cfg.json" ;;

M.f() ;;
N.f();;
