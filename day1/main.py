file=open("input.txt")

bags=[]
total=0
for line in file.readlines():
    if(line!="\n"):
        total+=int(line)
    else:
        bags.append(total)
        total=0
print(max(bags))
bags=sorted(bags)
print(bags[len(bags)-3:len(bags)])