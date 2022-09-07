nums = [1,2,3,4,5,6,7,8,9]

i = 1

for j in range(len(nums)-1):
    if (nums[i] - nums[j]) == 1:
        print(i)
    i+= 1