


@enum Direction begin
    EMPTY=0
    N=1
    S=2
    W=3
    E=4
    STAY=5
end

movetranslations=Dict(N=>(-1,0),S=>(1,0),W=>(0,-1),E=>(0,1),STAY=>(0,0))

function checkorder(d::Direction)::Vector{Int64} #defines order to check directions in based on what you're checking first, returns no range if direction is empty
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

function fillgrid(out::String,scale::Int64=2)::Array{Bool,2}

    lines=split(out,"\n")
    inputdims=(length(lines),length(lines[1]))
    gridsize=inputdims.*scale
    grid=fill(false ,gridsize) #compare datatypes
    innergridstart=Int.(floor.(gridsize./2)).-Int.(floor.(inputdims./2))
    innergridend=innergridstart.+inputdims
    innergrid=@view grid[innergridstart[1]:innergridend[1],innergridstart[2]:innergridend[2]]
    for line=1:inputdims[1],char=1:inputdims[2]
        innergrid[line,char]=lines[line][char]=='#' ? true : false
    end
    return grid
end

function anyany(grid,y,x)::Bool

    for i=(-1,0,1)
        for j=(-1,0,1)
            if i!=0 && j!=0 && grid[y+i,x+j]
                return true
            end
        end
    end
    return false
end

function proposedmoves(grid::Array{Bool,2},checkfirst::Direction)::Dict{Tuple{Int64, Int64}, Tuple{Int64, Int64}}
    movetranslations=((-1,0),(1,0),(0,-1),(0,1),(0,0))
    sizey,sizex=size(grid)
    moveorder=checkorder(checkfirst)
    
    moves::Dict{Tuple{Int64, Int64}, Tuple{Int64, Int64}}=Dict()
    @inbounds for y=2:sizey-1,x=2:sizex-1
        @inbounds current=@view grid[y-1:y+1,x-1:x+1]
        n=@view current[1,1:3]
        s=@view current[3,1:3]
        w=@view current[1:3,1]
        e=@view current[1:3,3]
        views=(n,s,w,e)
        #if grid[y,x] display(current) end
        #find possible move, populate proposed move grid
        @inbounds if grid[y,x] && any(any.(views))  #if nighbors are not empty and neither is the current cell   ##any causes lots of allocations and is really slow
            for dir in moveorder
                if !(any(views[dir]))  #if there's any neighbors in the current search direction
                    @inbounds moves[(y,x)]=(y,x).+movetranslations[dir]
                    break
                end
            end
        end
        @inbounds if !((y,x) in keys(moves)) && grid[y,x]
            moves[(y,x)::Tuple{Int64, Int64}]=(y,x)::Tuple{Int64, Int64}
        end
    end
    return moves  
end

function removeConflicts(moves)::Dict{Tuple{Int64, Int64}, Tuple{Int64, Int64}}
    #check move grid for conflicting moves
    moveto::Dict{Tuple{Int64, Int64}, Tuple{Int64, Int64}}=Dict()
    invalid=[]
    #push destination=>from to moveto dict, if that key is already found, then add the pairing to the invalid array
    for item in moves
        @inbounds if item[2] in keys(moveto)
            push!(invalid,item)
        else
            @inbounds moveto[item[2]]=item[1]
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

function generatemoves(grid::Array{Bool,2},checkfirst)
    return (removeConflicts∘proposedmoves)(grid,checkfirst)
end

function makeMoves!(grid::Array{Bool,2},newgrid::Array{Bool,2},moves)
    for item in moves
        to,from=item
        ty,tx=to
        fy,fx=from
        @inbounds newgrid[ty,tx]=true
        @inbounds grid[fy,fx]=false
    end
end

function step!(grid,newgrid,checkfirst)
    movesfromto=proposedmoves(grid,checkfirst)
    movestofrom=removeConflicts(movesfromto)
    makeMoves!(grid,newgrid,movestofrom)
    return movestofrom
end

function smallestRectangle(grid)
    sizey,sizex=size(grid)
    sx,sy,bx,by=sizey,sizex,0,0
    for y=1:sizey,x=1:sizex

        @inbounds if grid[y,x]
            sx=min(sx,x)
            sy=min(sy,y)
            bx=max(bx,x)
            by=max(by,y)
        end

    end
    return @view grid[sy:by,sx:bx]
end

function noMoves(movesdict)
    for (key,val) in movesdict
        if !(key==val)
            return false
        end
    end
    return true
end

function solve(out::String,steps::Int64)::Int64
    checkfirst=N
    grid=fillgrid(out,2)
    
    sizey,sizex=size(grid)
    newgrid=fill(false,sizey,sizex)

    for i=1:steps
        step!(grid,newgrid,checkfirst)
        grid,newgrid=newgrid,grid
        checkfirst=Direction(checkorder(checkfirst)[2])
    end

    smallrect=smallestRectangle(grid)
    ans=prod(size(smallrect))-sum(smallrect)
    return ans
end

function solve2(out::String)::Int64
    checkfirst=N
    grid=fillgrid(out,4)
    sizey,sizex=size(grid)
    newgrid=fill(false,sizey,sizex)
    iter=1
    while true
        moves=step!(grid,newgrid,checkfirst)
        if noMoves(moves)
            break
        end
        grid,newgrid=newgrid,grid
        checkfirst=Direction(checkorder(checkfirst)[2])
        iter+=1
    end
    return iter
end


f=open("input.txt")
out=read(f,String)

using StatProfilerHTML
using BenchmarkTools
using TimerOutputs
#@btime display(solve(out,100))
#@show @btime solve($out,$100)
display(solve(out,10))

display(solve2(out))
