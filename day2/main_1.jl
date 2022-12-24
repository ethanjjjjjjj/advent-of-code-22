f=open("input.txt","r") 
out::String=read(f,String)

function solve(lines::String)::Int32
    scores=Base.ImmutableDict('A'=>1,'B'=>2,'C'=>3,'X'=>1,'Y'=>2,'Z'=>3)
    turns=split(lines ::String,"\n")
    score::Int32=0
    turn=turns[1]
    for i=1:length(turns)
        turn=turns[i]
        sl::Int64,sr::Int64=scores[turn[1]],scores[turn[3]]
        score+=sr
        score+= ifelse((sl==sr),3,0)
        e=(sr-sl)!=2
        f=(sr>sl)||((sl-sr)==2)
        score+=ifelse(f&&e,6,0)
    end
    return score
end

display(solve(out))