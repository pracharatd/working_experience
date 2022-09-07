def findTheDifference(s: str, t: str) -> str:
    list_t = list(t)
    dict_t = dict.fromkeys(list_t,0)
    for i in t:
        dict_t[i] += 1
    for j in s:
        dict_t[j] -= 1
    for k in dict_t:
        if dict_t[k] == 1:
            return k    

findTheDifference('asdlqkowpqsda','asdlqkowpqseda')