f=open("input.txt","r")

lines=read(f,String)


dupes=[]

lines=split(lines) .|> (x->(x[1:ceil(Int32,length(x)/2)],x[ceil(Int32,length(x)/2)+1:end]))

display(length(lines))

for line in lines
    for char in line[1]
        if contains(line[2],char)
            push!(dupes,char)
            break
        end
    end
end

scores=[]
for item in dupes
    itemval=Int(item)
    if itemval>=65 && itemval<97
        push!(scores,itemval-65+27)
    elseif itemval>=97
        push!(scores,itemval-96)
    end
end

display(dupes)

display(sum(scores))