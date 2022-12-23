f=open("input.txt","r")

liness=read(f,String)

using Pipe

function solve()
    lines=split(liness,"\n")
    count=0
    for line in lines

        out=@pipe collect(eachmatch(r"(\d+)",line)) .|> x->x[1] 
        low1,high1,low2,high2=parse.(Int32,out)
        
        if (low1<=low2 && high1>=high2) || (low2<=low1 && high2>=high1)
            count+=1
        end
    end

    return count
end

display(solve())