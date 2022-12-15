
f=open("sack.txt","r")

lines=read(f,String)
lines=split(lines,"\n")
badges=[]

for i in 1:3:length(lines)-1
    for character in lines[i]
        if character in lines[i+1] && character in lines[i+2]
            push!(badges,character)
            break
        end
    end
end
scores=[]
for item in badges
    itemval=Int(item)
    if itemval>=65 && itemval<97
        push!(scores,itemval-65+27)
    else
        push!(scores,itemval-96)
    end
end
println(sum(scores))