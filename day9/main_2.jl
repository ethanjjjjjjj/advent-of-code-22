translations=Dict('R'=>[0,1],'U'=>[1,0],'L'=>[0,-1],'D'=>[-1,0])

function magnitude(A::Vector{Int64})
    sum(A.^2)/length(A)
end

function showgrid(HeadAbsolute::Vector{Int64},TailAbsolute::Vector{Int64},visits::Set{Any})
    grid=fill('.',(6,6))
    for item in visits
        grid[item[1],item[2]]='#'
    end
    grid[TailAbsolute[1],TailAbsolute[2]]='T'
    grid[HeadAbsolute[1],HeadAbsolute[2]]='H'
    
end
    

function showlocalGrid(tailrelative)
    grid=fill('.',(5,5))
    grid[3,3]='H'
    grid[([3,3]-tailrelative)[1],([3,3]-tailrelative)[2]]='T'
    display(grid[end:-1:1,:])
end


f=open("input.txt")
lines=read(f,String)


function movehead()
    visits=Set()
    tailabsolute=fill([1,1],10)
    for line in split(lines,"\n")
        instruction=match(r"(\S) (\d+)",line) 
        direction=instruction[1][1]
        number=parse(Int32,instruction[2])
        for i=1:number
            tailabsolute[1]+=translations[direction]
            for tailindex=2:10
                tailrelative=tailabsolute[tailindex-1]-tailabsolute[tailindex]
                if magnitude(tailrelative)>1
                    tailabsolute[tailindex]+=clamp.(tailrelative,-1,1)
                end
            end
            push!(visits,tailabsolute[10])
        end
    end
    return length(visits)
end

using BenchmarkTools
display(movehead())

