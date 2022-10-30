def removeElement(nums, val):
    i = 0
    for j in nums:
        if j != val:
            nums[i] = j
            i += 1
    return i

nums = [3,2,2,3]
val = 3
removeElement(nums,val)
