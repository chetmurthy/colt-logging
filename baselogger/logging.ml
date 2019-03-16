open Sexplib0.Sexp_conv

let __LOGGER_CONFIG_ENVIRONMENT_VARIABLE = "LOGGER_CONFIG"

type severity_t =
  | FATAL
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
  | TRACE9 [@@deriving yojson, sexp, show]

let severity_t_to_string = function
  | FATAL -> "FATAL"
  | ERROR -> "ERROR"
  | WARN -> "WARN"

  | INFO0 -> "INFO0"
  | INFO1 -> "INFO1"
  | INFO2 -> "INFO2"
  | INFO3 -> "INFO3"
  | INFO4 -> "INFO4"
  | INFO5 -> "INFO5"
  | INFO6 -> "INFO6"
  | INFO7 -> "INFO7"
  | INFO8 -> "INFO8"
  | INFO9 -> "INFO9"

  | DEBUG0 -> "DEBUG0"
  | DEBUG1 -> "DEBUG1"
  | DEBUG2 -> "DEBUG2"
  | DEBUG3 -> "DEBUG3"
  | DEBUG4 -> "DEBUG4"
  | DEBUG5 -> "DEBUG5"
  | DEBUG6 -> "DEBUG6"
  | DEBUG7 -> "DEBUG7"
  | DEBUG8 -> "DEBUG8"
  | DEBUG9 -> "DEBUG9"

  | TRACE0 -> "TRACE0"
  | TRACE1 -> "TRACE1"
  | TRACE2 -> "TRACE2"
  | TRACE3 -> "TRACE3"
  | TRACE4 -> "TRACE4"
  | TRACE5 -> "TRACE5"
  | TRACE6 -> "TRACE6"
  | TRACE7 -> "TRACE7"
  | TRACE8 -> "TRACE8"
  | TRACE9 -> "TRACE9"

type sink_t =
  | STDERR
  | STDOUT
  | OC of out_channel

module Logger = struct
  type t = {
      name : string ;
      mutable pass : severity_t ;
      mutable log : severity_t ;
      mutable sink : sink_t ;
      mutable flush : bool ;
      parent : t option ;
    }

  let dump oc l =
    Printf.fprintf stderr "name=<<%s>> pass=%s log=%s flush=%b\n"
      l.name (severity_t_to_string l.pass) (severity_t_to_string l.log) l.flush ;
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
      pass : (severity_t option [@default None]) ;
      log : (severity_t option [@default None]) ;
      filename : (string option [@default None]) ;
      flush : (bool option [@default None]) ;
    } [@@deriving yojson, sexp, show]

         type list_t = t list [@@deriving yojson, sexp, show]

  let configs = ref []

  let adjust1 c l =
    (match c.pass with None -> () | Some v -> l.Logger.pass <- v) ;
    (match c.log with None -> () | Some v -> l.Logger.log <- v) ;
    (match c.flush with None -> () | Some v -> l.Logger.flush <- v) ;

    match l.Logger.sink, c.filename with
    | _, None -> ()
    | STDERR, Some "<stderr>" -> ()
    | STDOUT, Some "<stdout>" -> ()
    | _, Some fname ->
       let oc = open_out fname in
       at_exit (fun () -> close_out oc) ;
       l.Logger.sink <- OC oc

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
    pass = INFO9 ;
    log = INFO9 ;
    sink = STDERR ;
    flush = true ;
    parent = None ;
    } in
  _register l ;
  Config.adjust l ;
  l

let sublogger l extname =
  let l = Logger.{
    l with
    name = l.name ^"."^ extname ;
    parent = Some l ;
    } in
  _register l ;
  Config.adjust l ;
  l

let will_log l ~line sev =
  sev <= l.Logger.log || sev <= l.Logger.pass

let format_line ~sev ~name ~line ~msg =
  let sev_string = severity_t_to_string sev in
  let time_s = () |> Unix.gettimeofday |> Netdate.mk_internet_date in
  Printf.sprintf "%s [%s %d] %s %s\n" time_s name line sev_string msg

let rec log1 sev l ~line ~properties msg =
  if sev <= l.Logger.log then
    let fmtline = format_line ~sev ~name:l.Logger.name ~line ~msg in
    let oc =
      match l.sink with
      | STDOUT -> stdout
      | STDERR -> stderr
      | OC oc -> oc in
    output_string oc fmtline ;
    if l.flush then flush oc ;
    match sev <= l.pass, l.parent with
    | true, Some p ->
       log1 sev p ~line ~properties msg
    | _ -> ()

let make_printer sev =
  (fun l ~line ?properties msg ->
    log1 sev l ~line ~properties msg
  )

type printer_t = Logger.t -> line:int -> ?properties:(string * string) list -> string -> unit

let (fatal : printer_t) = make_printer FATAL
let (error : printer_t) = make_printer ERROR
let (warn : printer_t) = make_printer WARN

let (info0 : printer_t) = make_printer INFO0
let (info1 : printer_t) = make_printer INFO1
let (info2 : printer_t) = make_printer INFO2
let (info3 : printer_t) = make_printer INFO3
let (info4 : printer_t) = make_printer INFO4
let (info5 : printer_t) = make_printer INFO5
let (info6 : printer_t) = make_printer INFO6
let (info7 : printer_t) = make_printer INFO7
let (info8 : printer_t) = make_printer INFO8
let (info9 : printer_t) = make_printer INFO9

let (debug0 : printer_t) = make_printer DEBUG0
let (debug1 : printer_t) = make_printer DEBUG1
let (debug2 : printer_t) = make_printer DEBUG2
let (debug3 : printer_t) = make_printer DEBUG3
let (debug4 : printer_t) = make_printer DEBUG4
let (debug5 : printer_t) = make_printer DEBUG5
let (debug6 : printer_t) = make_printer DEBUG6
let (debug7 : printer_t) = make_printer DEBUG7
let (debug8 : printer_t) = make_printer DEBUG8
let (debug9 : printer_t) = make_printer DEBUG9

let (trace0 : printer_t) = make_printer TRACE0
let (trace1 : printer_t) = make_printer TRACE1
let (trace2 : printer_t) = make_printer TRACE2
let (trace3 : printer_t) = make_printer TRACE3
let (trace4 : printer_t) = make_printer TRACE4
let (trace5 : printer_t) = make_printer TRACE5
let (trace6 : printer_t) = make_printer TRACE6
let (trace7 : printer_t) = make_printer TRACE7
let (trace8 : printer_t) = make_printer TRACE8
let (trace9 : printer_t) = make_printer TRACE9
