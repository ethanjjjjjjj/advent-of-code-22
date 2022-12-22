
f=open("input.txt","r")

lines=read(f,String)
lines=split(lines,"\n")

function solve()
    score=0
    for i in 1:3:length(lines)-1
        for character in lines[i]
            if character in lines[i+1] && character in lines[i+2]
                itemval=Int(character)
                score+=itemval<97 ? itemval-65+27 : itemval-96
                break
            end
        end
    end
    return score
end

display(solve())