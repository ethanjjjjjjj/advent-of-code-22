include("main.jl")

using Test


#first example
f=open("example2.txt")
out=read(f,String)


grid=fillgrid(out,2)
testgrid=fill(false,12,10)
testgrid[4,5]=true
testgrid[5,5]=true
testgrid[4,6]=true
testgrid[7,5]=true
testgrid[7,6]=true

expectedsize=(12,10)
esy,esx=expectedsize

@test length(out)==35
@test size(grid)==expectedsize
@test grid==testgrid




grid2=copy(grid)
newgrid=fill(false,esy,esx)

testgrid2=fill(false,12,10)
testgrid2[3,5]=true
testgrid2[3,6]=true
testgrid2[5,5]=true
testgrid2[7,5]=true
testgrid2[6,6]=true


#test moves before they are tested for invalid
generatedmoves=proposedmoves(copy(grid2),N)
@test generatedmoves[(4,5)]==(4,5).+movetranslations[N]
@test generatedmoves[(5,5)]==(5,5).+movetranslations[S]
@test generatedmoves[(4,6)]==(4,6).+movetranslations[N]
@test generatedmoves[(7,5)]==(7,5).+movetranslations[N]
@test generatedmoves[(7,6)]==(7,6).+movetranslations[N]


#test one whole step
@test begin step!(grid2,newgrid,N) ; newgrid end == testgrid2




#test number of elves does not change
begin
    f=open("example2.txt")
    out=read(f,String)

    local grid=fillgrid(out,4)
        
    sizey,sizex=size(grid)
    local newgrid=fill(false,sizey,sizex)
    local checkfirst=N

    elfcount=sum(grid)
    for i=1:100
        step!(grid,newgrid,checkfirst)
        grid,newgrid=newgrid,grid
        @test sum(grid)==elfcount
        checkfirst=Direction(checkorder(checkfirst)[2])
    end
end

f=open("example.txt")
out=read(f,String)

@test solve(out,10)==110

# performance

using BenchmarkTools

tests=["fillgrid","generatemoves","step"]

suite=BenchmarkGroup()

suite["fillgrid"] = @benchmarkable fillgrid($out)
grid=fillgrid(out)
suite["generatemoves"] = @benchmarkable generatemoves($grid,$N)
suite["step"]=@benchmarkable step!($grid,$newgrid,$N)


function runbench()
    tune!(suite,seconds=10,evals=10)
    results=run(suite)
    display(results)
end

#runbench()

f=open("example.txt")
out=read(f,String)

