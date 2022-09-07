num_digit = int(input("Enter Digit: "))
column = num_digit - 1

for row in range (0, num_digit):
    for j in range (0, column):
        print (end = ' ')
    column -= 1
    for j in range (0, 1):
        if row == 0:
            print (end = '*')
        elif row != ((num_digit+1)/2)-1:
            print ("*"+' '*(2*row-1), end = '*')
            break
        else:
            print (end = "*"*num_digit)
        
        
    print ("\r")