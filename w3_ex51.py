import random
generate = []
[generate.append(str(random.randint(0,9))) for i in range (0,8)]
#print (int(''.join(sorted(generate,reverse = True))))
#print (int(''.join(sorted(generate))))
print((int(''.join(sorted(generate,reverse = True)))) - (int(''.join(sorted(generate)))))