from re import L


def strStr(haystack, needle):
    if needle in haystack:
        found = haystack.find(needle)
        return found
strStr("mississippi","issip")