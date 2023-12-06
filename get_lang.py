import json
import os
import random

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

    fp.write("\n")
    fp.write(f"### Day {dirs}\n")
    fp.write(f"**{lang}**\n")
