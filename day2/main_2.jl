#rock A X 1
#paper B Y 2
#scissors C Z 3

scores=Dict('A'=>1,'B'=>2,'C'=>3,'X'=>1,'Y'=>2,'Z'=>3)
wins=Dict('A'=>'B','B'=>'C','C'=>'A')
losses=Dict('A'=>'C','B'=>'A','C'=>'B')


function scorefunc(x::Char,y::Char)::Int32
    score=0
    if x==y
        score+=3
    elseif scores[x]==1 && scores[y]==3 #scissors lose to rock
        score+=0
    elseif scores[x]==3 && scores[y]==1 #rock win to scissors
        score+=6
    elseif scores[x]>scores[y] # you lose to opponent
        score+=0
    elseif scores[y]>scores[x] #you win to opponent
        score+=6
    end
    score+=scores[y]
    return score
end


f=open("input.txt","r")
out=read(f,String)
function solve()
    turns=((x->split.(x," "))∘split)(out,"\n",keepempty=false)
    play=""
    tot_score=0
    for item in turns
        item=only.(item)
        if item[2]=='X'
            play=losses[item[1]]
        elseif item[2]=='Y'
            play=item[1]
        elseif item[2]=='Z'
            play=wins[item[1]]
        end
        score=scorefunc(item[1],play)
        tot_score+=score
    end
    return
end

display(solve())