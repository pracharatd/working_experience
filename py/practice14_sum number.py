def split(word):
    return [char for char in word]

number = input(("Enter: "))
a = split(number)
b = []
for i in a:
    b.append(int(i))

c = sum(b)
print(c)