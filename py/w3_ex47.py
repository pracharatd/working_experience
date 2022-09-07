def ex47(input_word):
    input_list1 = input_word.removesuffix('.')
    input_list = input_list1.split()
    input = dict.fromkeys(input_list, 0)


    for i in range(len(input_list)):
        for j in input:
            if j == input_list[i]:
                input[j] += 1

    max_duplicate = max(input, key=input.get)

    input1 = dict.fromkeys(input_list, 0)

    for i in input_list:
        count = len(i)
        input1[i] = count

    max_character = max(input1, key=input1.get)

    print(max_duplicate +' '+max_character)

ex47('Thank you for your comment and your participation.')