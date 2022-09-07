def romantointeger(s):
    collect = []
    i = 0
    x = 0
    while i < len(s)-1:
        if s[i] == 'I':
            if s[i+1] == 'V':
                collect.append(4)
                i+=2
                continue
            elif s[i+1] == 'X':
                collect.append(9)
                i+=2
                continue
            else:
                collect.append(1)
                i+=1
                continue
        if s[i] == 'V':
            collect.append(5)
            i+=1    
            continue
        if s[i] == 'X':
            if s[i+1] == 'L':
                collect.append(40)
                i+=2
                continue
            elif s[i+1] == 'C':
                collect.append(90)
                i+=2
                continue
            else:
                collect.append(10)
                i+=1
                continue
        if s[i] == 'L':
            collect.append(50)
            i+=1
            continue
        if s[i] == 'C':
            if s[i+1] == 'D':
                collect.append(400)
                i+=2
                continue
            elif s[i+1] == 'M':
                collect.append(900)
                i+=2
                continue
            else:
                collect.append(10)
                i+=1
                continue
        if s[i] == 'D':
            collect.append(500)
            i+=1
            continue
        if s[i] == 'M':
            collect.append(1000)
            i+=1
            continue
    if i < len(s):
        if s[i] == 'I':
            collect.append(1)
        elif s[i] == 'V':
            collect.append(5)
        elif s[i] == 'X':
            collect.append(10)
        elif s[i] == 'L':
            collect.append(50)
        elif s[i] == 'C':
            collect.append(100)
        elif s[i] == 'D':
            collect.append(500)
        elif s[i] == 'M':
            collect.append(1000)
    x = sum(collect)
    print (x)
romantointeger('XLCDCMLVMCMVII')