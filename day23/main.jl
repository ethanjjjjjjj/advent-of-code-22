
@enum Direction begin
    EMPTY=0
    N=1
    S=2
    W=3
    E=4
    STAY=5
end

movetranslations=Dict(N=>(-1,0),S=>(1,0),W=>(0,-1),E=>(0,1),STAY=>(0,0))

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

function fillgrid(out::String)

    lines=split(out,"\n")
    inputdims=(length(lines),length(lines[1]))
    gridsize=inputdims.*2
    grid=fill(false ,gridsize) #compare datatypes
    innergridstart=Int.(ceil.(inputdims./2))
    innergridend=innergridstart.+inputdims
    innergrid=@view grid[innergridstart[1]:innergridend[1],innergridstart[2]:innergridend[2]]
    for line=1:inputdims[1],char=1:inputdims[2]
        innergrid[line,char]=lines[line][char]=='#' ? true : false
    end
    return grid
end


function proposedmoves(grid,checkfirst)
    sizey,sizex=size(grid)
    moveorder=checkorder(checkfirst)
    
    moves=Dict()
    for y=2:sizey-1,x=2:sizex-1
        current=@view grid[y-1:y+1,x-1:x+1]
        n=@view current[1,1:3]
        s=@view current[3,1:3]
        w=@view current[1:3,1]
        e=@view current[1:3,3]
        views=[n,s,w,e]
        #find possible move, populate proposed move grid
        if any(any.((n,s,e,w))) && (x->Int(x)!=0)(grid[y,x]) #if nighbors are not empty and neither is the current cell
            for dir in moveorder
                if !(any(map(x->Int(x)!=0,views[dir])))  #if there's any neighbors in the current search direction
                    moves[(y,x)]=(y,x).+movetranslations[Direction(dir)]
                    break
                end
                if !((y,x) in keys(moves))
                    moves[(y,x)]=(y,x)
                end
            end
        end
    end
    return moves  
end

function removeConflicts(moves)
    #check move grid for conflicting moves
    moveto=Dict()
    invalid=[]
    #push destination=>from to moveto dict, if that key is already found, then add the pairing to the invalid array
    for item in moves
        if item[2] in keys(moveto)
            push!(invalid,item)
        else
            moveto[item[2]]=item[1]
        end
    end
    #iterate over all invalid, set their destination to be same as source (no move), as well as correct already proposed move in moveto
    for move in invalid
        source,dest=move
        #store source then delete duplicate dest
        update=moveto[dest]
        delete!(moveto,dest)
        #change dest so that the source does not move
        moveto[update]=update
        #also store the key that is invalid into movelist as an item which does not move
        moveto[source]=source

    end
    return moveto
end

function generatemoves(grid,checkfirst)
    return removeConflicts∘proposedmoves(grid,checkfirst)
end

function makeMoves!(grid,newgrid,moves)
    for item in moves
        to,from=item
        newgrid[to[1],to[2]]=true
        grid[from[1],from[2]]=false
    end
end

function step!(grid,newgrid,checkfirst)
    movesfromto=proposedmoves(grid,checkfirst)
    movestofrom=removeConflicts(movesfromto)
    makeMoves!(grid,newgrid,movestofrom)
end

function smallestRectangle(grid)
    sizey,sizex=size(grid)
    sx,sy,bx,by.=0
    for y=1:sizey,x=1:sizex

        
    end
end


function solve(out)
    checkfirst=N
    grid=fillgrid(out)
    sizey,sizex=size(grid)
    println("start grid")
    newgrid=fill(false,sizey,sizex)
    


    for i=1:10
        @time step!(grid,newgrid,checkfirst)
        grid,newgrid=newgrid,grid
        checkfirst=Direction(checkorder(checkfirst)[2])
    end

end



