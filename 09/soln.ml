open String
open List

let get_lines file =
  let ic = open_in file in
  let rec build_list acc =
    try
      let line = input_line ic in
      build_list (line :: acc)
    with
    | End_of_file -> acc
  in
  build_list [] |> List.rev
;;

let rec differences vals =
  match vals with
  | []
  | [ _ ] ->
    []
  | x :: y :: xs -> (y - x) :: differences (y :: xs)
;;

let rec is_linear vals =
  match vals with
  | []
  | [ _ ] ->
    true
  | x :: y :: xs -> x = y && is_linear (y :: xs)
;;

let solve f lines =
  let vals_for line = line |> split_on_char ' ' |> map int_of_string in
  lines |> map vals_for |> map f |> fold_left ( + ) 0
;;

let part1 lines =
  let rec next_for vals =
    match vals with
    | []
    | [ _ ] ->
      failwith "invalid input"
    | vs when is_linear vs -> hd vs
    | vs -> (vs |> rev |> hd) + (vs |> differences |> next_for)
  in
  lines |> solve next_for
;;

let part2 lines =
  let rec prev_for vals =
    match vals with
    | []
    | [ _ ] ->
      failwith "invalid input"
    | vs when is_linear vs -> hd vs
    | vs -> (vs |> hd) - (vs |> differences |> prev_for)
  in
  lines |> solve prev_for
;;

let () =
  let lines = get_lines "./input.txt" in
  part1 lines |> string_of_int |> print_endline ;
  part2 lines |> string_of_int |> print_endline ;
;;
