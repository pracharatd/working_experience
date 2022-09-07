h = int(input("Height: "))
w = int(input("Weight: "))

for i in range (0,h):
    if i == 0:
        print(end = '*'*w)
    if i>0 and i<h-1:
        print('*'+' '*(w-2), end = '*')
    if i == h-1:
        print(end = '*'*w)
    print ('\r')