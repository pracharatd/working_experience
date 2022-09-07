def isValid( str_paren: str) -> bool:
    lib = {'(':')', '[':']', '{':'}'}
    char = []

    if(len(str_paren) % 2 != 0):
        return False
        
    for i in str_paren:
        if i in lib:
            char.append(i)
        else:
            if len(char) == 0:
                return False
            if i == ')':
                if char.pop() != '(':
                    return False
            elif i == ']':
                if char.pop() != '[':
                    return False
            elif i == '}':
                if char.pop() != '{':
                    return False
    if len(char) == 0:
        print ("True")
    else:
        return False

isValid("{{}[]()[(){}]{{()[([])]}()}}")