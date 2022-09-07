num_digit = int(input("Enter Digit: "))
column = num_digit - 1

for row in range (0, num_digit):
    for j in range (0, column):
        print (end = ' ')
    column -= 1
    for j in range (0, row+1):
        if row >= ((num_digit+1)/2)-1:
            print ("*", end = ' ')
        elif row <= ((num_digit+1)/2)-1:
            print (end = "* ")
        else:
            print ("*", end = '*')
        
        
    print ("\r")