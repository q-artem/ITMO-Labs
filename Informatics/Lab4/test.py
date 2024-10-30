


def f(h):
    h["sd"] = 7

d = dict()

d["sd"] = dict()
d["sd"]["ada"] = 4

print(d)

f(d)
print(d)

print("dasd".split(" "))

file = open("output.yaml", "w", encoding="utf-8")
file.write("234234")
file.write("234234\n")
file.write("234234")
file.close()