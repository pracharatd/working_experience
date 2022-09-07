def containsDuplicate(nums):
    if len(dict.fromkeys(nums)) != len(nums):
        return True
    else:
        return False