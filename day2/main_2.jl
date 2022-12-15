#rock A X 1
#paper B Y 2
#scissors C Z 3

scores=Dict('A'=>1,'B'=>2,'C'=>3,'X'=>1,'Y'=>2,'Z'=>3)

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


function findwin(x::Char)::Char
    if x=='A'
        return 'B'
    elseif x=='B'
        return 'C'
    elseif x=='C'
        return 'A'
    end
end


function findDraw(x::Char)::Char
    return x

end


function findLoss(x::Char)::Char
    if x=='B'
        return 'A'
    elseif x=='C'
        return 'B'
    elseif x=='A'
        return 'C'
    end
end


open("input.txt","r") do f
    out=read(f,String) #convert to chars
    turns=((x->split.(x," "))∘split)(out,"\n",keepempty=false)
    play=""
    tot_score=0
    for item in turns
        item=only.(item)
        if item[2]=='X'
            play=findLoss(item[1])
        elseif item[2]=='Y'
            play=findDraw(item[1])
        elseif item[2]=='Z'
            play=findwin(item[1])
        end
        score=scorefunc(item[1],play)
        tot_score+=score
    end
    println(tot_score)
end
