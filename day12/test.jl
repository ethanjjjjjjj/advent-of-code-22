include("main.jl")

using Test

file=open("example.txt","r")
out=read(file,String)
start= findfirst.('S',out)
out=collect.(split(out,"\n"))
sizes=length(out),length(out[1])
d(index)=Int(ceil(index/(sizes[2]))),((index-1)%sizes[2])+1
startindex=d(start)
close(file)

@testset "can move" begin
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

end


@testset "gen Neighbours" begin
    @test genNeighbours((1,1),out)==Set([(1,2),(2,1)])
    @test genNeighbours((2,2),out)==Set([(1,2),(2,1),(3,2),(2,3)])
    @test genNeighbours((3,3),out)==Set([(2,3),(3,2),(4,3),(3,4)])
    @test genNeighbours((4,1),out)==Set([(5,1),(3,1),(4,2)])
end

@testset "generate Moves" begin
    @test generateMoves(startindex,out)==Set([(1,2),(2,1)])
    @test generateMoves((2,2),out)==Set([(1,2),(2,1),(3,2),(2,3)])

    @test generateMoves((3,3),out)==Set([(2,3),(3,2),(4,3)])
    @test generateMoves((3,1),out)==Set([(2,1),(4,1)])
    @test generateMoves((4,1),out)==Set([(5,1),(3,1)])

end




@testset "solutions" begin
    file=open("example.txt","r")
    out=read(file,String)
    @test solve(out)==31
    @test solve2(out)==29
    @test solveastar(out)==31

    file=open("input.txt","r")
    out=read(file,String)
    @test solve(out)==517
    @test solve2(out)==512
    @test solve2(out)==512
    @test solve2(out)==512
    @test solve2(out)==512
    @test solve2(out)==512
    

end

