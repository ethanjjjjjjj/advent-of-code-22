function toData(s::Union{String,SubString{String}})
    return Meta.parse(s) |> eval
end

Base.length(::Nothing)=0



function compare(L::Int,R::Int)#
    return L<=R
end

function compare(L::Vector{Any},R::Vector{Any})

    return all(compare.(L,R[:length(L)]))

function compare(L::Vector{Any},R::Vector{Any})




function compareeach((L,R))
    if length(L)==1 && length(R)==1
        return L<=R
    elseif length(L)==0
        return true
    #elseif length(L)>length(R)
    #    return false
    else
        return all(compareeach.(zip(L,R)))
    end
end

function compare(L,R)
    #println(L,R)
    #println(all(compareeach.(zip(L,R))))
    return all(compareeach.(zip(L,R)))
end

function solve(out::String)
    lines=split(out,"\n")
    correctpackets=0
    for i=1:2:length(lines)
        L=toData(lines[i])
        R=toData(lines[i+1])

        if compare(L,R) correctpackets+=1 end
    end
    return correctpackets
end
        