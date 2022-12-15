file=open("input.txt") #open the file called input.txt

lines=file.readlines() #read all the lines from the file into a list

total=0 #set initial total to 0

scores=[] #make an empty list to store the sums from each backpack

for line in lines: #loop through each line from the file
    if line=="\n": #if the line is blank 
        scores.append(total) 
        total=0
    else:
        total=total+int(line)

scores=sorted(scores)

scores=list(reversed(scores))

print(sum(scores[0:3]))