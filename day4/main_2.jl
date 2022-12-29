using Pipe
f=open("input.txt","r")
inlines= read(f,String) 

function splitline(s::Union{String,SubString{String}},delim::Char)
    index=1
    @inbounds while s[index+1]!=delim
        index+=1
    end
    @inbounds return SubString(s,1,index) , SubString(s,index+2,length(s))
end

function solve(inlines)
    lines=split(inlines,"\n")
    count=0
    for line in lines
        (low1,high1),(low2,high2)=@pipe splitline(line,',') .|> splitline.(_,'-') .|> parse.(Int,_)
        count+=(low2 <= high1 && high2 >=low1) || (low2 >= low1 && high2 <= high1)
    end

    return count
end
using BenchmarkTools
@assert solve(inlines)==827