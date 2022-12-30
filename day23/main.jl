
@enum Direction begin
    EMPTY=0
    N=1
    S=2
    W=3
    E=4
    STAY=5
end

function checkorder(d::Direction) #defines order to check directions in based on what you're checking first, returns no range if direction is empty
    if d==EMPTY return [] end
    D=Int(d)
    return vcat(D:4,1:D-1)
end

function symdir(d::Direction)
    if d==N return "⬆" 
    elseif d==S return "⬇"
    elseif d==E return "➡"
    elseif d==W return "⬅"
    elseif d==STAY return "."
    elseif d==EMPTY return "."
    end
end


Base.display(g::Array{Direction,2})=display(map(symdir,g))



function fillgrid(out::String)

    lines=split(out,"\n")
    inputdims=(length(lines),length(lines[1]))
    gridsize=inputdims.*2
    grid=fill(EMPTY,gridsize) #compare datatypes
    innergridstart=Int.(ceil.(inputdims./2))
    innergridend=innergridstart.+inputdims
    innergrid=@view grid[innergridstart[1]:innergridend[1],innergridstart[2]:innergridend[2]]
    for line=1:inputdims[1],char=1:inputdims[2]
        innergrid[line,char]=lines[line][char]=='#' ? N : EMPTY
    end
    return grid
end


function solve(out)
    checkfirst=N
    grid=fillgrid(out)
    sizey,sizex=size(grid)
    println("start grid")
    


    for i=1:3
    display(grid)
    moveorder=checkorder(checkfirst)
    movegrid=fill(STAY,sizey,sizex)
    newgrid=fill(EMPTY,sizey,sizex)

    for y=2:sizey-1,x=2:sizex-1
        
        current=@view grid[y-1:y+1,x-1:x+1]
        n=@view current[1,1:3]
        s=@view current[3,1:3]
        w=@view current[1:3,1]
        e=@view current[1:3,3]
        views=[n,s,w,e]

        
        #find possible move, populate proposed move grid
        if any(any.(map.(x->Int(x)!=0,(n,s,e,w))))
            
            for dir in moveorder
                if !(any(map(x->Int(x)!=0,views[dir]))) && (x->Int(x)!=0)(grid[y,x])
                    movegrid[y,x]=Direction(dir)
                    break
                    
                end
            end
        end

    end  


    #check move grid for conflicting moves
    movetranslations=Dict(N=>(-1,0),S=>(1,0),W=>(0,-1),E=>(0,1))
    #moves list
    moveto=Dict()
    invalid=Set()
    #println("destinations")
    for y=2:sizey-1,x=2:sizex-1
        current=movegrid[y,x]
        if current!=STAY
            destination=(y,x).+movetranslations[current]
           
            #println((y,x),destination)
            if !(destination in keys(moveto))
                moveto[destination]=(y,x)
            else
                push!(invalid,(y,x))
                push!(invalid,moveto[destination])
            end
        end
    end
    
    #remove invalid moves from planned moves, tell elves to search in next direction next time
    for move in invalid
        y=move[1]
        x=move[2]
        movegrid[y,x]=STAY
       
        
    end
    println("moves")
    #display(invalid)
    display(movegrid)
    


    #make moves
    for y=2:sizey-1,x=2:sizex-1
        if movegrid[y,x]!=STAY
            newpos=(y,x).+ movetranslations[movegrid[y,x]]
            ny,nx=newpos
            newgrid[ny,nx]=N
            grid[y,x]=EMPTY
        elseif grid[y,x]!=EMPTY
            newgrid[y,x]=grid[y,x]
        end
    end

    temp=grid
    grid=newgrid
    newgrid=temp
    #println("finalgrid")
    #display(grid)
    checkfirst=Direction(checkorder(checkfirst)[2])
    end

end


f=open("example2.txt")


out=read(f,String)

@assert solve(out) == 110
