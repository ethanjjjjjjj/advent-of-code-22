using DataStructures

f=open("input.txt","r")

lines=read(f,String)
#lines=split(lines,"\n")


initialstacks=match(r"((.+\n+)+)\n",lines)[1]

columns=match(r"(\d+ +)+(\d+)",initialstacks)[2]
columns=parse(Int32,columns)
stacks=[Stack{Char}() for x=1:9]

stacklines=split(initialstacks,"\n")
stacklines=stacklines[1:length(stacklines)-2]
reverse!(stacklines)
display(stacklines)


for line in stacklines
    for (iteration,i) in enumerate(2:4:length(line))
        if line[i]!=' '
            push!(stacks[iteration],line[i])
        end
    end
end

instructions=eachmatch(r"move (\d+) from (\d+) to (\d+)",lines)
for instruction in instructions
    number=parse(Int32,instruction[1])
    from=parse(Int32,instruction[2])
    to=parse(Int32,instruction[3])
    acc=Stack{Char}()
    for i = 1:number
        push!(acc,pop!(stacks[from]))
        
    end
    for i = 1:number
        push!(stacks[to],pop!(acc))
        
    end
    
end

for stack in stacks
    println(pop!(stack))
end
close(f)