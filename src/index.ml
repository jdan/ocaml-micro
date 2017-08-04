(* FFI *)
type req
external url : req -> string = "url" [@@bs.get]

type res
external write : res -> string -> unit = "end" [@@bs.send]

type server
external listen : server -> int -> unit = "listen" [@@bs.send]
external micro : (req -> res -> 'a) -> server = "micro" [@@bs.module]

(* utils && server *)
let slice str start =
  String.sub str start ((String.length str) - start)

let write_lines res lines = write res (
  List.fold_left
    (fun acc -> fun line -> acc ^ line ^ "\n")
    ""
    lines)

let server = micro (fun req -> fun res ->
  let name = slice (url req) 1
  in write_lines res [
    "<!doctype html>" ;
    "<html>" ;
    "<head>" ;
      "<title>Hello, " ^ name ^ "!</title>" ;
      "<style>" ;
        "body {" ;
          "margin: 0;" ;
          "padding: 0;" ;
          "height: 100vh;" ;
          "display: flex;" ;
          "align-items: center;" ;
          "justify-content: center;" ;
        "}" ;

        "h1 {" ;
          "font-family: Georgia;" ;
          "font-size: 60px;" ;
        "}" ;
      "</style>" ;
    "</head>" ;
    "<body>" ;
      "<h1>Welcome to " ^ name ^ "'s Webpage!</h1>" ;
    "</body>" ;
    "</html>" ;
  ]
)

(* spawn server *)
let port : int = [%bs.raw "parseInt(process.env.PORT) || 3000"];;
listen server port;;
Js.log ("Server listening on port " ^ (string_of_int port));;
