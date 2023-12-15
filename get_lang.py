import json
import os
import random

URL = "https://adventofcode.com/2023/day/"

# Stack Overflow Developer Survey 2023
langs: list[str] = [
    "JavaScript",
    "HTML/CSS",
    "Python",
    "SQL",
    "TypeScript",
    "Shell",
    "Java",
    "C#",
    "C++",
    "C",
    "PHP",
    "Powershell",
    "Go",
    "Rust",
    "Kotlin",
    "Ruby",
    "Lua",
    "Dart",
    "Assembly",
    "Swift",
    "R",
    "Visual Basic",
    "Matlab",
    "VBA",
    "Groovy",
    "Delphi",
    "Scala",
    "Perl",
    "Elixir",
    "Objective-C",
    "Haskell",
    "GDScript",
    "Lisp",
    "Solidity",
    "Clojure",
    "Julia",
    "Erlang",
    "F#",
    "Fortran",
    "Prolog",
    "Zig",
    "Ada",
    "OCaml",
    "Apex",
    "Cobol",
    "SAS",
    "Crystal",
    "Nim",
    "APL",
    "Flow",
    "Raku",
]

index = random.randrange(1, len(langs) + 1)
lang = langs[index - 1]
print("Language:", lang)

with open("README.md", "a") as fp:
    dirs = max([int(dir) for dir in os.listdir("./") if dir.isdigit()]) + 1
    print(dirs)

    os.mkdir(f"./{dirs}")
    fp.write(f"| {dirs} | [*REPLACE_ME*]({URL}{dirs}) | **{lang}** | |\n")
