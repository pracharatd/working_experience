def SQ(num):
    length = len(num)
    i = 0
    output_SQ = []
    while i < length:
        if (i+1) % 3 != 0:
            num.append(num[i])
            length += 1
        i += 1
    for i in range(2,len(num),3):
        output_SQ.append(num[i])
    print(output_SQ)

#SQ([10,20,30,40,50,60,70,80,90])

def SQ2(num):
    position = 2
    while len(num) > 0:
        print(num.pop(2))

