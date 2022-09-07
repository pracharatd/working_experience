input_list = ['Him','Best','Wutt','Him','Wutt']
input = dict.fromkeys(input_list, 0)

for i in range(len(input_list)):
    for j in input:
        if j == input_list[i]:
            input[j] += 1

print (input)