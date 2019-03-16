
module M = struct
LOGGER EXTEND M
let f() =
LOG "%d" ~properties:[] 1 LEVEL INFO0 ;
()
end

module N = struct
LOGGER EXTEND N
let f() =
LOG "%d" ~properties:[] 2 LEVEL TRACE9 ;
if (IS_LOGGING TRACE9) then
  LOG "YES logging TRACE9" LEVEL INFO0 ;
()

end

LOG "%d" ~properties:[] 3 LEVEL DEBUG9 ;;

M.f() ;;
N.f();;

Logging.Config.from_file "baselog-cfg.json" ;;

M.f() ;;
N.f();;
