def plusone(digits):
    num = ''
    for i in digits:
        num = num+str(i)
    num = int(num)+1
    ans = list(str(num))
    return (ans)

x = [1, 2, 3]
plusone(x)