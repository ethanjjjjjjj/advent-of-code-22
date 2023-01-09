

Base.@pure function canMakeMove(current::Char,destination::Char)
    if (destination == 'E') && (current < 'y' || current=='S') return false
    elseif current=='S' && destination < 'c' return true
    elseif current>=destination return true
    elseif current+1==destination return true
    else return false
    end
end
Base.@pure function genNeighbours((y,x),grid::Vector{Vector{Char}})
    sizes=length(grid),length(grid[1])
    indexes::Set{Tuple{Int64,Int64}}=Set()
    for translation=[(-1,0),(1,0),(0,1),(0,-1)]
        newcoord=((y,x).+translation)
        if ((newcoord.>0) |> all) && ((newcoord.<=sizes) |> all) && ((newcoord.!=(y,x)) |> any)
            push!(indexes,newcoord)
        end
    end
    return indexes
end

Base.@pure function generateMoves((y,x),grid::Vector{Vector{Char}})
    neighbours=genNeighbours((y,x),grid)
    current=grid[y][x]
    destinations((y,x))=grid[y][x]
    moveFromCurrent(destination)=canMakeMove(current,destination)
    return filter(moveFromCurrent∘destinations,neighbours)
end
    return 

Base.@pure function path(location::Tuple{Int64,Int64},visited::Set{Tuple{Int64,Int64}},grid,movenum::Int64)
    if grid[location[1]][location[2]]=='E' return movenum end
    visited=copy(visited)
    push!(visited,location)
    trymoves=generateMoves(location,grid)
    unvisited=setdiff(trymoves,visited)
    if(length(unvisited))==0 return 100000 end
    lengths=[]

    Threads.@threads for move in collect(unvisited)
        push!(lengths,path(move,visited,grid,movenum+1))
    end
    return minimum(lengths)
end

#with help from https://www.geeksforgeeks.org/a-search-algorithm/
function astar(startindex::Tuple{Int64,Int64},endindex::Tuple{Int64,Int64},grid)
    openL::Vector{Tuple{Int64,Int64}}=[startindex]
    closedL::Vector{Tuple{Int64,Int64}}=[]
    nodes=Dict{Tuple{Int64,Int64},Tuple{Int64,Float32,Float32}}() # position (y,x)=>(g,h,f)
    #g(x)=sum(x.-startindex)
    h(x)=sqrt(sum((endindex.-x).^2))
    #valstuple(x)=(g(x),h(x),f(x))
    nodes[startindex]=(0,0,0)
    currentnode::Tuple{Int64,Int64}=startindex
    while length(openL)!=0
        item,itemindex=findmin(map(x->x[3],[getindex(nodes,item) for item in openL])) #look up lowest f of items in openL
        currentnode=openL[itemindex]
        currentnodevals=nodes[currentnode]
        deleteat!(openL,itemindex) #remove said item from openL
        successors=generateMoves(currentnode,grid)
        for item in successors
            successorvals=(currentnodevals[1]+1,h(item),currentnodevals[1]+1+h(item))
            if grid[item[1]][item[2]]=='E'
                return currentnodevals[1]+1
            end
            if (item in openL) && nodes[item][3]<successorvals[3]
                #do nothign
            else
                nodes[item]=successorvals
            end
            if (item in closedL) && nodes[item][3]<successorvals[3]
                deleteat!(closedL,findall(x->x==item,closedL))
                push!(openL,item)
            elseif !(item in openL) && !(item in closedL)
                push!(openL,item)
                nodes[item]=successorvals
            end 
        end
        push!(closedL,currentnode)
    end
end


function solve(out::String)
    start= findfirst.('S',out)
    endi= findfirst.('S',out)
    
    grid=collect.(split(out,"\n"))
    sizes=length(grid),length(grid[1])
    d(index)=Int(ceil(index/(sizes[2]))),((index-1)%sizes[2])+1
    startindex=d(start)
    endindex=d(endi)
    return astar(startindex,endindex,grid)
    #return path(startindex,Set{Tuple{Int64,Int64}}([]),grid,0)
end


using Test

file=open("example.txt","r")
out=read(file,String)
start= findfirst.('S',out)
out=collect.(split(out,"\n"))
sizes=length(out),length(out[1])
d(index)=Int(ceil(index/(sizes[2]))),((index-1)%sizes[2])+1
startindex=d(start)
close(file)

@test canMakeMove('m','n')==true
@test canMakeMove('m','o')==false
@test canMakeMove('m','a')==true
@test canMakeMove('S','a')==true
@test canMakeMove('S','b')==true
@test canMakeMove('S','c')==false
@test canMakeMove('S','E')==false
@test canMakeMove('y','E')==true
@test canMakeMove('x','E')==false

@test canMakeMove('c','c')

@test genNeighbours((1,1),out)==Set([(1,2),(2,1)])
@test genNeighbours((2,2),out)==Set([(1,2),(2,1),(3,2),(2,3)])
@test genNeighbours((3,3),out)==Set([(2,3),(3,2),(4,3),(3,4)])
@test genNeighbours((4,1),out)==Set([(5,1),(3,1),(4,2)])


@test generateMoves(startindex,out)==Set([(1,2),(2,1)])
@test generateMoves((2,2),out)==Set([(1,2),(2,1),(3,2),(2,3)])

@test generateMoves((3,3),out)==Set([(2,3),(3,2),(4,3)])
@test generateMoves((3,1),out)==Set([(2,1),(4,1)])
@test generateMoves((4,1),out)==Set([(5,1),(3,1)])


file=open("example.txt","r")
out=read(file,String)

@test solve(out)==31
close(file)


file=open("input.txt","r")
out=read(file,String)


display(solve(out))

