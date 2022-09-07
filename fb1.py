first = ['A']
fora = ['B','C','G','D','E']
forb = ['F']
forc = ['F','J','G']
ford = ['G','K','H']
fore = ['H']
forf = ['I','M','J']
forg = ['J','K']
forh = ['K','O','L']
fori = ['M']
forj = ['M','N']
fork = ['N','O']
forl = ['O']
form = ['N','P']
forn = ['P','Q']
foro = ['N','Q']
forp = ['R']
forq = ['R']

collect1 = []
collect2 = []
collect3 = []
collect4 = []
collect5 = []
collect6 = []
collect7 = []

for i in range(len(fora)):
    collect1.append(first[0]+fora[i])
for j in range(len(collect1)):
    if collect1[j][-1] == 'B':
        for k in forb:
            collect2.append(collect1[j] + k)
    if collect1[j][-1] == 'C':
        for k in forc:
            collect2.append(collect1[j] + k)
    if collect1[j][-1] == 'G':
        for k in forg:
            collect2.append(collect1[j] + k)
    if collect1[j][-1] == 'D':
        for k in ford:
            collect2.append(collect1[j] + k)
    if collect1[j][-1] == 'E':
        for k in fore:
            collect2.append(collect1[j] + k)
for j in range(len(collect2)):
    if collect2[j][-1] == 'F':
        for k in forf:
            collect3.append(collect2[j] + k)
    if collect2[j][-1] == 'J':
        for k in forj:
            collect3.append(collect2[j] + k)
    if collect2[j][-1] == 'G':
        for k in forg:
            collect3.append(collect2[j] + k)
    if collect2[j][-1] == 'K':
        for k in fork:
            collect3.append(collect2[j] + k)
    if collect2[j][-1] == 'H':
        for k in forh:
            collect3.append(collect2[j] + k)
for j in range(len(collect3)):
    if collect3[j][-1] == 'I':
        for k in fori:
            collect4.append(collect3[j] + k)
    if collect3[j][-1] == 'M':
        for k in form:
            collect4.append(collect3[j] + k)
    if collect3[j][-1] == 'J':
        for k in forj:
            collect4.append(collect3[j] + k)
    if collect3[j][-1] == 'N':
        for k in forn:
            collect4.append(collect3[j] + k)
    if collect3[j][-1] == 'K':
        for k in fork:
            collect4.append(collect3[j] + k)
    if collect3[j][-1] == 'O':
        for k in foro:
            collect4.append(collect3[j] + k)
    if collect3[j][-1] == 'L':
        for k in forl:
            collect4.append(collect3[j] + k)
for j in range(len(collect4)):
    if collect4[j][-1] == 'M':
        for k in form:
            collect5.append(collect4[j] + k)
    if collect4[j][-1] == 'N':
        for k in forn:
            collect5.append(collect4[j] + k)
    if collect4[j][-1] == 'P':
        for k in forp:
            collect5.append(collect4[j] + k)
    if collect4[j][-1] == 'Q':
        for k in forq:
            collect5.append(collect4[j] + k)
    if collect4[j][-1] == 'O':
        for k in foro:
            collect5.append(collect4[j] + k)
for j in range(len(collect5)):
    if collect5[j][-1] == 'N':
        for k in forn:
            collect6.append(collect5[j] + k)
    if collect5[j][-1] == 'P':
        for k in forp:
            collect6.append(collect5[j] + k)
    if collect5[j][-1] == 'Q':
        for k in forq:
            collect6.append(collect5[j] + k)
for j in range(len(collect6)):
    if collect6[j][-1] == 'P':
        for k in forp:
            collect7.append(collect6[j] + k)
    if collect6[j][-1] == 'Q':
        for k in forq:
            collect7.append(collect6[j] + k)

for i in collect6:
    if i[-1] == 'R':
        collect7.append(i)
for i in collect5:
    if i[-1] == 'R':
        collect7.append(i)

collect7.sort()

for i in range(0,len(collect7)):
        collect7[i] = '-'.join(collect7[i])

count = 1
for i in range(len(collect7)):
    print(str(count) + '. ' + collect7[i] )
    count += 1