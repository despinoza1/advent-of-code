import json
import os
import random

URL = "https://adventofcode.com/2023/day/"

langs: list
with open("languages.json", "r") as fp:
    langs = json.load(fp)

index = random.randrange(1, len(langs) + 1)
lang = langs[index]
print("Language:", lang)

with open("README.md", "a") as fp:
    dirs = max([int(dir) for dir in os.listdir("./") if dir.isdigit()]) + 1
    print(dirs)

    os.mkdir(f"./{dirs}")
    fp.write(f"| {dirs} | [*REPLACE_ME*]({URL}{dirs}) | **{lang}** |\n")
