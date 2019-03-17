type severity_t = EMERG | ALERT | CRIT | ERROR | WARN | NOTICE | INFO | DEBUG
val severity_t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> severity_t
val sexp_of_severity_t : severity_t -> Ppx_sexp_conv_lib.Sexp.t
val severity_t_to_yojson : severity_t -> Yojson.Safe.json
val severity_t_of_yojson :
  Yojson.Safe.json -> severity_t Ppx_deriving_yojson_runtime.error_or
val pp_severity_t :
  Format.formatter -> severity_t -> Ppx_deriving_runtime.unit
val show_severity_t : severity_t -> Ppx_deriving_runtime.string
val severity_t_to_level : severity_t -> Netlog.level
val severity_t_to_string : severity_t -> string
module Logger :
  sig
    type t
  end
module Config :
  sig
    val from_file : string -> unit
    val from_environment : unit -> unit
  end
val create : string -> Logger.t
val sublogger : Logger.t -> string -> Logger.t
val will_log : Logger.t -> line:int -> severity_t -> bool
type printer_t =
    Logger.t ->
    line:int -> ?properties:(string * string) list -> string -> unit
val emerg : printer_t
val alert : printer_t
val crit : printer_t
val error : printer_t
val warn : printer_t
val notice : printer_t
val info : printer_t
val debug : printer_t
