scores=Dict("A"=>1,"B"=>2,"C"=>3,"X"=>1,"Y"=>2,"Z"=>3)

f=open("input.txt","r") 
out=read(f,String)

function solve()
    turns=((x->split.(x," "))∘split)(out,"\n",keepempty=false)
    score=0
    for game in turns
        score+=scores[game[2]]
        if (scores[game[2]]>scores[game[1]] || scores[game[1]] - scores[game[2]]==2) && scores[game[2]] - scores[game[1]]!=2
            score+=6
        elseif scores[game[2]]==scores[game[1]]
            score+=3
        end
    end
    return score
end

display(solve())