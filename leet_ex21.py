def mergeTwoLists(list1,list2):
    for num in range(len(list2)):
        list1.append(list2[num])
    list1.sort()
    print(list1)
    
mergeTwoLists([1,2,3],[0,1,2])