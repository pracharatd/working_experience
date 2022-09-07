s = """my.song.mp3 555b 
betty.mp4 10mb 
Batman.org 19b
123.pdf 20lb
ab.com 200tb
pic.jpeg 10gb
abc.py 10qb
ok.gif 1mb
org.map 100kb"""

list_s = (s.split('\n'))
split_list_s = [i.split() for i in list_s]
collect = []
type_s = []
for i in split_list_s:
    for j in range (len(i)):
        if len(i[j].split('.')) != 1:
            type_s.append(i[len(i)-1])
    for k in reversed(i):
        if '.' in k:
            file = k.split('.')
            collect.append(file[len(file)-1])
for p in type_s:
    if 'k' in p:
        type_s[type_s.index(p)] = int(p.replace('kb',''))*(10**3)      
    if 'm' in p:
        type_s[type_s.index(p)] = int(p.replace('mb',''))*(10**6)
    if 'g' in p:
        type_s[type_s.index(p)] = int(p.replace('gb',''))*(10**9)
    if 'a' in p or 'c' in p or 'd' in p or 'e' in p or 'f' in p or 'h' in p or 'i' in p or 'j' in p or 'l' in p or 'n' in p or 'o' in p or 'p' in p or 'q' in p or 'r' in p or 's' in p or 't' in p or 'u' in p or 'v' in p or 'w' in p or 'x' in p or 'y' in p or 'z' in p:
        type_s[type_s.index(p)] = 'Type Error'
for i in reversed(range (len(type_s))):
    if type_s[i] == 'Type Error':
        type_s.pop(i)
        collect.pop(i)
print([[collect[q],type_s[q]] for q in range((len(collect)))])