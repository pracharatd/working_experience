def longeststring(strs):
    strs.sort()
    start = strs[0]
    
    for word in strs[1::1]:
        i = 0
        
        while i < len(strs[0]):
            if start not in word:
                start = start[:len(start)-1]
            i+=1
    for word in strs[1::1]:
        if start not in word[0:len(start)]:
            return ''
    if len(start) == 0:
        return ''
    else:
        return start
longeststring(['flower','flight','reflower'])