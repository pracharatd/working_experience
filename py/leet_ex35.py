def searchinsertposition(num, target):
    i = 0
    ans = 0
    while i <= len(num)-1:
        if num[i] >= target:
            break
        i += 1    
    return i

searchinsertposition([1,3,5,6],7)