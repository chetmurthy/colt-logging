let logging_levels =
  [
    "EMERG";
    "ALERT";
    "CRIT";
    "FATAL";
    "ERROR";
    "WARN";

    "NOTICE";
    "INFO0";
    "INFO1";
    "INFO2";
    "INFO3";
    "INFO4";
    "INFO5";
    "INFO6";
    "INFO7";
    "INFO8";
    "INFO9";
    "INFO";

    "DEBUG0";
    "DEBUG1";
    "DEBUG2";
    "DEBUG3";
    "DEBUG4";
    "DEBUG5";
    "DEBUG6";
    "DEBUG7";
    "DEBUG8";
    "DEBUG9";
    "DEBUG";

    "TRACE0";
    "TRACE1";
    "TRACE2";
    "TRACE3";
    "TRACE4";
    "TRACE5";
    "TRACE6";
    "TRACE7";
    "TRACE8";
    "TRACE9";
    "TRACE";
  ]

let level_to_int_map = Hashtbl.create 23
let _ = List.mapi (fun i level -> Hashtbl.add level_to_int_map level i) logging_levels

let level_to_int s =
  if not (Hashtbl.mem level_to_int_map s) then
    failwith (Printf.sprintf "logging level %s not configured in preprocessor" s) ;
  Hashtbl.find level_to_int_map s

let logger_module = ref "Logging"
let set_logger_module s = logger_module := s

let logger_level = ref "TRACE9"
let set_level s =
  if not (Hashtbl.mem level_to_int_map s) then
    failwith (Printf.sprintf "logging level %s not configured in preprocessor" s) ;
  logger_level := s

let remove_from_code lvl =
  (level_to_int lvl) > (level_to_int !logger_level)

let module_of_file file =
  let basename = Filename.basename file in
  String.capitalize_ascii (try Filename.chop_extension basename with _ -> basename)

let unpack e =
  let rec urec acc =
    function
    | MLast.ExApp (_, e1, e2) -> urec (e2::acc) e1
    | MLast.ExStr(_, _) as e -> (e, acc)
    | _ -> failwith "first expression in LOG must be a string"
    in urec [] e

let is_labeled e =
  match e with
  | <:expr< ~{$_:i$ = $e2$ }>> -> true
  | <:expr< ~{$_:i$ }>> -> true
  | _ -> false

let not_labeled e =
  match e with
  | <:expr< ~{$_:i$ = $e2$ }>> -> false
  | <:expr< ~{$_:i$ }>> -> false
  | _ -> true

(*
let not_labeled e = not(is_labeled e)
 *)
let filter p =
  let rec filter_aux = function
      [] -> []
    | x::l -> if p x then x::filter_aux l else filter_aux l
  in filter_aux

let applist loc e el =
  let rec apprec e = function
    | [] -> e
    | h::t -> apprec <:expr< $e$ $h$ >>  t
  in apprec e el

let make_printf loc (e,el) =
  let ebase = <:expr:<Printf.sprintf>> in
  applist loc ebase (e::el)

let make_log_0 lvl loc labeled =
  let line = string_of_int (Ploc.line_nb loc) in
  applist loc <:expr< $uid:(!logger_module)$.$lid:lvl$ __logger__ ~{line = $int:line$} >> labeled

let make_log lvl loc labeled format_e =
  let log_0 = make_log_0 lvl loc labeled in
  <:expr< $log_0$ $format_e$ >>

let transl e lvl =
  let loc = MLast.loc_of_expr e in
  if remove_from_code lvl then <:expr< () >> else
  let lclvl = String.lowercase_ascii lvl in
  let (e0, el) = unpack e in
  let labeled = filter is_labeled el in
  let unlabeled = filter not_labeled el in
  let format_e = make_printf loc (e0, unlabeled) in
  let log_e = make_log lclvl loc labeled format_e in
  let line = string_of_int (Ploc.line_nb loc) in
  <:expr<if $uid:!logger_module$.will_log __logger__ ~{line = $int:line$} $uid:lvl$ then
           $log_e$
         else ()>>

EXTEND
    Pcaml.expr: LEVEL "simple" 
          [[ "LOG"; e = Pcaml.expr; "LEVEL"; lvl = UIDENT ->
	    transl e lvl
      ]];
END;;

let declare loc name =
  <:str_item< value __logger__ = $uid:!logger_module$.sublogger __logger__ $str:name$ >>

EXTEND
    Pcaml.str_item:
          [[ "LOGGER"; "EXTEND"; name = UIDENT ->
	    declare loc name ;
      ]];
END;;



let insert_this loc =
  let fname = Ploc.file_name loc in
  let modname = module_of_file fname in
  (<:str_item< value __logger__ = $uid:!logger_module$.create $str:modname$ >>, loc)

let _ =
  let first = ref true in
  let parse strm =
    let (l, stopped) = Grammar.Entry.parse Pcaml.implem strm in
    let l' = 
      if !first then
        let (_, loc) = List.hd l in
        (insert_this loc) :: l
      else l in
    (l', stopped) in
  Pcaml.parse_implem := parse

let _ = Pcaml.add_option "-logger" (Arg.String set_logger_module)
          "<string> Set logger module."

let _ = Pcaml.add_option "-level" (Arg.String set_level)
          "<string> Set logging level (more verbose than this is removed from code)."
