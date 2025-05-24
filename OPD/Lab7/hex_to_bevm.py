

start = "02A"
start = int(start, 16)
end = "7EF"
end = int(end, 16)

with open("output.hex", "r") as f:
    lines = f.readlines()
    r = "WORD "
    byte = []
    for q in lines:
        w = q.strip().split()[::-1]
        for e in range(5):
            byte.append("0x")
            byte[-1] += w[e*2]
            byte[-1] += w[e * 2 + 1]
    r += ", ".join(byte[:end - start + 1])
    print(r)




