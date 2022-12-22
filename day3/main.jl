f=open("input.txt","r")

lines=read(f,String)


function solve(lines)
    lines=split(lines) .|> (x->(x[1:Int(end/2)],x[Int(end/2)+1:end]))

    score=0
    for line in lines
        for char in line[1]
            if contains(line[2],char)
                itemval=Int(char)
                val=itemval<97 ? itemval-65+27 : itemval-96
                score+=val
                break
            end
        end
    end

    return score
end


display(solve(lines))