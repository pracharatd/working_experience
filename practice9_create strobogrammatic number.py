input_number = str(input("Enter Number: "))
a = ''
for i in input_number:
    if i == str(9):
        a += '6'
    elif i == str(6):
        a += '9'
    else:
        a += i
c = len(a) - 1

if a[0] == '6' and a[c] == '9':
    b = a
    print (b)
elif a[0] == '9' and a[c] == '6':
    b = a
    print (b)
else:
    b = a[::-1]
    print (b)