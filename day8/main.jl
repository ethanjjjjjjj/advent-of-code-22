
f=open("input.txt")
lines=read(f,String)


lines=split(lines,"\n")

dims=(length(lines),length(split(lines[1],"")))

lines=split.(lines,"")

numbersgrid= parse.(Int32,Iterators.flatten(lines))
numbersgrid=reshape(numbersgrid,dims)
numbersgrid=transpose(numbersgrid)

using BenchmarkTools
using LoopVectorization
function trees(n)::Int32

total=0
    for rowindex = 1:dims[1]
        for colindex=1:dims[2]
            a=numbersgrid[begin:rowindex-1,colindex]
            b=numbersgrid[rowindex+1:end,colindex]
            c=numbersgrid[rowindex,begin:colindex-1]
            d=numbersgrid[rowindex,colindex+1:end]
            neighbors=[a,b,c,d]
            maxneighbors=[length(x) >0 ? maximum(x) : 0 for x in neighbors]
            visibles=(numbersgrid[rowindex,colindex]>x || (rowindex==1 || rowindex==dims[1] || colindex==1 || colindex==dims[2]) for x in maxneighbors)
            total+=Int32(any(visibles))
        end
    end
    return total
end

total=trees(numbersgrid)
display(total)
