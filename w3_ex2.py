import random

test = ['a','e','i','o','u']
random.shuffle(test)
print (test)

"""collect = []
for i in range(len(test)):
    collect.append(random.choice(test))
    test.remove(collect[i])
print(collect)"""