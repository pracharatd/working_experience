row = int(input("Enter Row: "))
half = int((row+1)/2)

for i in range (0, half-1):
    for j in range (0, half-1):
        print (end = ' ')
    half -= 1
    for j in range (0,1):
        print (end = '*'*((2*i)+1))
    print('\r')

print ('*'*row)

half = int((row+1)/2)
a = half -1

for i in range (0, half-1):
    for j in range (a, half ):
        print (end = ' ')
    a -= 1
    for j in range (0,1):
        print (end = '*'*((row-2)-(2*i)))
    print('\r')