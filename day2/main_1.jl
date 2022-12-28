f=open("input.txt","r") 
out::String=read(f,String)

function solve(lines::String)::Int32
    score::Int32=0
    @inbounds @simd ivdep for i=1:4:length(lines)
        @inbounds sl=Int(lines[i])-64
        @inbounds sr=Int(lines[i+2])-64
        sl=ifelse(sl>3,sl-23,sl)
        sr=ifelse(sr>3,sr-23,sr)
        e=(sr-sl)!=2
        f=(sr>sl)||((sl-sr)==2)
        score+=ifelse(f&&e,6,0)+ifelse((sl==sr),3,0) + sr
    end
    return score
end

@assert solve(out) == 13484
