def addBinary(a, b):
    sum = str(int(a)+int(b))
    p = list(map(int, str(sum)))
    p = p[::-1]
    for i in range(len(p)-1):
        if p[i] >= 2:
            p[i] = p[i] - 2
            p[i+1] = p[i+1] + 1
    if p[len(p)-1] >= 2:
        p[len(p)-1] = p[len(p)-1] - 2
        p.append(1)
    q = "".join(map(str,p[::-1]))
    return q

a = "101011"
b = "10111101"
addBinary(a,b)
