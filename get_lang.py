import json
import random

langs: list
with open("languages.json", "r") as fp:
    langs = json.load(fp)

index = random.randrange(1, len(langs) + 1)
print("Language:", langs[index])
