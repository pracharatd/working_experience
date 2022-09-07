def removeDuplicates(nums):
    replace = sorted(list(set(nums)))
    for i in range(len(replace)):
        nums[i] = replace[i]
    print (nums[:len(replace)])        

removeDuplicates([-1,0,0,0,3,3])