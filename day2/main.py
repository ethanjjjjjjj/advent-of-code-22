file=open("input.txt")

lines=file.readlines()

scores={'A':1,'B':2,'C':3}

score=0

for line in lines:
    elf=line[0]
    outcome=line[2]
    if outcome=='X': #lose
        if elf=='A': 
#if the elf plays rock we play scissors to lose
            score+=3
        else:  
            score+=scores[elf]-1
    if outcome=='Y': #draw
        score+=3
        score+=scores[elf]
    if outcome=='Z': #win
        score+=6
        if elf=='C':
            score+=1
        else:
            score+=scores[elf]+1
print(score)