def equal(num):
    for i in range(len(num)-1):
        for j in range(i+1,len(num)):
            if num[i] == num[j]:
                return False
    return True
equal([2,4,5,6,7,7])