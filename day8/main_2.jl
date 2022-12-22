
f=open("input.txt")
lines=read(f,String)

lines=split(lines,"\n")

dims=(length(lines),length(split(lines[1],"")))

lines=split.(lines,"")

numbersgrid= parse.(Int32,Iterators.flatten(lines))
numbersgrid=reshape(numbersgrid,dims)
numbersgrid=transpose(numbersgrid)

function distanceToBigger(n::Int32,ls::Vector{Int32})
    for (index,item) in enumerate(ls)
        if item>=n
            return index
        end
    end

    return length(ls)
end


function trees(numbersgrid)::Int32
    total=0
    for rowindex = 1:dims[1]
        for colindex=1:dims[2]
            a=reverse(numbersgrid[begin:rowindex-1,colindex])
            b=numbersgrid[rowindex+1:end,colindex]
            c=reverse(numbersgrid[rowindex,begin:colindex-1])
            d=numbersgrid[rowindex,colindex+1:end]
            value=numbersgrid[rowindex,colindex]
            neighbors=[a,b,c,d]
            distances=distanceToBigger.(value,neighbors)
            proda=prod(*,distances)
            total=max(total,proda)
        end
    end
    return total
end

total=trees(numbersgrid)
display(total)
