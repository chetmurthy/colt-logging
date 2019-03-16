open Sexplib0.Sexp_conv

type severity_t =
  | EMERG
  | ALERT
  | CRIT
  | ERROR
  | WARN
  | NOTICE
  | INFO
  | DEBUG [@@deriving yojson, sexp, show]

let (severity_t_to_level : severity_t -> Netlog.level) = function
  | EMERG -> `Emerg
  | ALERT -> `Alert
  | CRIT -> `Crit
  | ERROR -> `Err
  | WARN -> `Warning
  | NOTICE -> `Notice
  | INFO -> `Info
  | DEBUG -> `Debug

let __LOGGER_CONFIG_ENVIRONMENT_VARIABLE = "NETLOGGER_CONFIG"

let severity_t_to_string = function
  | EMERG -> "EMERG"
  | ALERT -> "ALERT"
  | CRIT -> "CRIT"
  | ERROR -> "ERROR"
  | WARN -> "WARN"
  | NOTICE -> "NOTICE"
  | INFO -> "INFO"
  | DEBUG -> "DEBUG"

type sink_t = {
    logger : Netlog.logger ;
    oc : out_channel ;
    close : bool ;
  }

module Logger = struct
  type t = {
      name : string ;
      mutable severity : severity_t ;
      mutable sink : sink_t ;
    }

  let dump oc l =
    Printf.fprintf stderr "name=<<%s>> severity=%s\n"
      l.name (severity_t_to_string l.severity) ;
    flush oc
end

let all_loggers = (Hashtbl.create 23 : (string, Logger.t) Hashtbl.t)
let _register l =
  Hashtbl.add all_loggers l.Logger.name l

let dump_loggers () =
  let dump1 name l =
    Printf.fprintf stderr "%s " name ;
    Logger.dump stderr l in
  Hashtbl.iter dump1 all_loggers ;
  flush stderr

module Config = struct
  type t = {
      name_pat : string ;
      severity : (severity_t option [@default None]) ;
      filename : (string option [@default None]) ;
    } [@@deriving yojson, sexp, show]

         type list_t = t list [@@deriving yojson, sexp, show]

  let configs = ref []

  let adjust1 c l =
    let must_reopen =
      match c.severity with
      | None -> false
      | Some v -> l.Logger.severity <- v; true in

    let switch_to l ?(close=false) oc =
      if l.Logger.sink.close then close_out l.Logger.sink.oc ;
      l.Logger.sink <- {
          logger = Netlog.channel_logger oc (severity_t_to_level l.Logger.severity) ;
          oc ;
          close ;
        } in
    
    match must_reopen, c.filename with
    | false, None -> ()
    | _, Some "<stderr>" ->
       switch_to l stderr
    | _, Some "<stdout>" ->
       switch_to l stdout
    | _, Some fname ->
       let oc = open_out fname in
       at_exit (fun () -> close_out oc) ;
       switch_to l ~close:true oc    
    | true, None ->
       l.Logger.sink <- {
          l.sink with
          logger = Netlog.channel_logger l.sink.oc (severity_t_to_level l.Logger.severity) ;
        }

  let adjust l =
    List.iter (fun (rex, c) ->
        if Pcre.pmatch ~pat:c.name_pat l.Logger.name then (
          adjust1 c l
        )
      ) !configs

  let from_file f =
    let cfg =
      f
      |> Yojson.Safe.from_file
      |> list_t_of_yojson in
    match cfg with
    | Result.Error s ->
       Printf.fprintf stderr "FATAL error during logger initialization: %s\n" s ;
       flush stderr ;
       failwith s
    | Result.Ok cfg ->
       let l =
         List.map (fun c ->
             (Pcre.regexp c.name_pat, c)) cfg in
       configs := l ;
       Hashtbl.iter (fun _ l -> adjust l) all_loggers

  let from_environment () =
    match Sys.getenv_opt __LOGGER_CONFIG_ENVIRONMENT_VARIABLE with
    | None -> ()
    | Some f ->
       try from_file f ;
           Printf.fprintf stderr "[Loaded logging config from file %s]\n" f ; flush stderr
       with Failure msg ->
         Printf.fprintf stderr "FATAL error during logger initialization: Failure %s\n" msg ;
         flush stderr ;
         exit (-1)

let _ = from_environment ()
end

let create name =
  let l = Logger.{
    name ;
    severity = INFO ;
    sink = { logger = Netlog.channel_logger stderr `Info ;
             oc = stderr ;
             close = false } ;
    } in
  _register l ;
  Config.adjust l ;
  l

let sublogger l extname =
  let l = Logger.{
    l with
    name = l.name ^"."^ extname ;
    } in
  _register l ;
  Config.adjust l ;
  l

let will_log l ~line sev =
  let _ = (line: int) in
  sev <= l.Logger.severity

let format_line ~name ~line ~msg =
  Printf.sprintf "[%s %d] %s\n" name line msg

let make_printer sev =
  (fun l ~line ?properties msg ->
    if sev <= l.Logger.severity then
      let line = format_line ~name:l.name ~line ~msg in
      l.sink.logger (severity_t_to_level sev) line
  )

type printer_t = Logger.t -> line:int -> ?properties:(string * string) list -> string -> unit

let (emerg : printer_t) = make_printer EMERG
let (alert : printer_t) = make_printer ALERT
let (crit : printer_t) = make_printer CRIT
let (error : printer_t) = make_printer ERROR
let (warn : printer_t) = make_printer WARN
let (notice : printer_t) = make_printer NOTICE
let (info : printer_t) = make_printer INFO
let (debug : printer_t) = make_printer DEBUG
