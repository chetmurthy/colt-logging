type severity_t =
    FATAL
  | ERROR
  | WARN
  | INFO0
  | INFO1
  | INFO2
  | INFO3
  | INFO4
  | INFO5
  | INFO6
  | INFO7
  | INFO8
  | INFO9
  | DEBUG0
  | DEBUG1
  | DEBUG2
  | DEBUG3
  | DEBUG4
  | DEBUG5
  | DEBUG6
  | DEBUG7
  | DEBUG8
  | DEBUG9
  | TRACE0
  | TRACE1
  | TRACE2
  | TRACE3
  | TRACE4
  | TRACE5
  | TRACE6
  | TRACE7
  | TRACE8
  | TRACE9
val severity_t_of_sexp : Ppx_sexp_conv_lib.Sexp.t -> severity_t
val sexp_of_severity_t : severity_t -> Ppx_sexp_conv_lib.Sexp.t
val severity_t_to_yojson : severity_t -> Yojson.Safe.json
val severity_t_of_yojson :
  Yojson.Safe.json -> severity_t Ppx_deriving_yojson_runtime.error_or
val pp_severity_t :
  Format.formatter -> severity_t -> Ppx_deriving_runtime.unit
val show_severity_t : severity_t -> Ppx_deriving_runtime.string
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
val will_log : Logger.t -> line:'a -> severity_t -> bool
type printer_t =
    Logger.t ->
    line:int -> ?properties:(string * string) list -> string -> unit
val fatal : printer_t
val error : printer_t
val warn : printer_t
val info0 : printer_t
val info1 : printer_t
val info2 : printer_t
val info3 : printer_t
val info4 : printer_t
val info5 : printer_t
val info6 : printer_t
val info7 : printer_t
val info8 : printer_t
val info9 : printer_t
val debug0 : printer_t
val debug1 : printer_t
val debug2 : printer_t
val debug3 : printer_t
val debug4 : printer_t
val debug5 : printer_t
val debug6 : printer_t
val debug7 : printer_t
val debug8 : printer_t
val debug9 : printer_t
val trace0 : printer_t
val trace1 : printer_t
val trace2 : printer_t
val trace3 : printer_t
val trace4 : printer_t
val trace5 : printer_t
val trace6 : printer_t
val trace7 : printer_t
val trace8 : printer_t
val trace9 : printer_t
