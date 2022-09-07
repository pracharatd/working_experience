w = int(input("weight: "))
h = int(input("height: "))
bmi = 0

if w <= 0 or h <= 0:    print ("Error")
else:
    hm = h/100
    bmi = w/((hm)**2)

if bmi < 18.5:    print("Underweight")
elif bmi < 25:    print("Normal")
else:    print("Overweight")
