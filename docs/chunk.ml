type meta_token =
  | CategoryForm of string * string
  | Category of string

let string_of_meta_token m =
  match m with
  | CategoryForm (k, v) -> k ^ ":" ^ v
  | Category x -> x

type token_syntax =
  | MetaToken of meta_token
  | Literal of string

let string_of_token t =
  match t with
  | MetaToken m -> "<" ^ (string_of_meta_token m) ^ ">"
  | Literal x -> x

type chunk_syntax =
  | Comment of string
  | TokenSequence of token_syntax list
  | Metadata of string * string
  | Newline
  | End

let string_of_chunk s =
  match s with
  | Comment x -> "#" ^ x
  | TokenSequence seq ->
    seq
    |> List.map string_of_token
    |> String.concat ","
  | Metadata (k, v) -> "&" ^ k ^ "=" ^ v
  | Newline -> "\n"
  | End -> ";"

type rule = chunk_syntax list

let string_of_rule r =
  r
  |> List.map string_of_chunk
  |> String.concat ""

type document = rule list

let string_of_document doc =
  doc
  |> List.map string_of_rule
  |> String.concat "\n\n"


(* main *)
let r = [
    Comment " Adverbial indicating the desire to perform an action."; Newline;
    TokenSequence [Literal"想要"; Literal "去"; MetaToken (Category "Verb")];
    Metadata ("meaning", "want to act");
    Metadata ("chunkType", "chunkType");
    End;
  ]

let _ =
  Printf.printf "%s\n" (string_of_rule r)
