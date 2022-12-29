f=open("input.txt","r")

out=read(f,String)

using Pipe
function splitline(s::Union{String,SubString{String}},delim::Char)
    index=1
    @inbounds while s[index+1]!=delim
        index+=1
    end
    @inbounds return SubString(s,1,index) , SubString(s,index+2,length(s))
end

function solve(out::String)
    lines=split(out,"\n")
    count=0
    @inbounds @simd ivdep for line in lines
        (low1,high1),(low2,high2)=@pipe splitline(line,',') .|> splitline.(_,'-') .|> parse.(Int,_)
        count+=(low1<=low2 && high1>=high2) || (low2<=low1 && high2>=high1)
    end

    return count
end


@assert solve(out)==503