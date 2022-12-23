using Pipe
f=open("input.txt","r")
inlines= read(f,String) 

function solve()
    lines=split(inlines,"\n")
    count=0
    for line in lines
        out=@pipe collect(eachmatch(r"(\d+)",line)) .|> x->x[1] 
        low1,high1,low2,high2=parse.(Int32,out)
        if (low2 <= high1 && high2 >=low1) || (low2 >= low1 && high2 <= high1)
            count+=1
        end
    end

    return count
end
using BenchmarkTools
display(solve())