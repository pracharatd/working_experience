def mySqrt(x):
    temp = 10000
    while temp*temp <= x:
        temp += 10000
    temp -= 10000
    while temp*temp <= x:
        temp += 1000
    temp -= 1000
    while temp*temp <= x:
        temp += 100
    temp -= 100
    while temp*temp <= x:
        temp += 10
    temp -= 10
    while temp*temp <= x:
        temp += 1
    if temp < 1:
        return 0
    elif temp == 1:
        return 1
    else:
        temp -= 1
        return temp

x = 10000
mySqrt(x)