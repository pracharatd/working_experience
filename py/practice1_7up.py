a = int(input("Enter: "))
b = []

for i in range(1,a+1):
    b = str(i)
    if i % 7 == 0:
        b = '7up'
    if '7' in str(i):
        b = '7up'
    print(b)