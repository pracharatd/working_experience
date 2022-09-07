input_digit = int(input("Enter Digit: "))
output = []

def middle(j):
    key = {"9": "6", "6": "9", "8": "8", "1": "1", "0": "0"}
    left = 0
    right = len(j)-1

    while left <= right:
        if j[left] in key and key[j[left]] == j[right]:
            left += 1
            right -= 1     
        else:
            return False
    return output.append(j)

for i in range (10**(input_digit-1), 10**input_digit):
    j = str(i)
    middle(j)

if input_digit == 1:
    output = (['1', '0', '8'])

print (list(dict.fromkeys(output)))