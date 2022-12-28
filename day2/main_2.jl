
f=open("input.txt","r")
out=read(f,String)
function solve(lines::String)
    tot_score=0
    @inbounds @simd ivdep for i=1:4:length(lines)
        @inbounds l=Int(lines[i])-64
        @inbounds r=Int(lines[i+2])-87
        win=ifelse(l>2,l+4,l+7)
        lose=ifelse(l>1,l-1,l+2)
        tot_score+=ifelse(r==1,lose,ifelse(r==2,l+3,win))
    end
    return tot_score 
end

@assert solve(out)==13433

