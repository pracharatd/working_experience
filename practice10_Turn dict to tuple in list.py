input = {'Him':['Mr', 'Wichapas', 'Darojana'], 'Wutt':['Mr', 'Wuttichai', 'Yingrod'], 'Best':['Mr', 'Pracharat', 'Duangchai']}
name = []

for i in input:
    name = '_'.join(input[i])
    input[i] = name

output = list(input.items())
print (output)