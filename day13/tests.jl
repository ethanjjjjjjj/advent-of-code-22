include("main.jl")


using Test
@testset "toData" begin

    @test toData("[1,2,3]")==[1,2,3]
    @test toData("[1]")==[1]
    @test toData("1")==1
    @test toData("[1,2,3,[1,2,3]]")==[1,2,3,[1,2,3]]
end

@testset "compare" begin
    @test compare([1],[1])==true
    @test compare(1,[1])==true
    @test compare([1],1)==true
    @test compare(1,1)==true
    @test compare(1,2)==true
    @test compare(1,[2])==true
    @test compare([1,1],[1,2])==true
    @test compare(2,[1])==false
end

@testset "redefine length of nothing" begin
    @test length(Nothing())==0
end

@testset "examplelines" begin
    @test compare([1,1,3,1,1],[1,1,5,1,1])==true
    @test compare([1],[1])==true
    @test compare([2,3,4],4)==true
    @test compare([[1],[2,3,4]],[[1],4])==true
    @test compare([9],[[8,7,6]])==false
    @test compare([[4,4],4,4],[[4,4],4,4,4])==true
    @test compare([7,7,7,7],[7,7,7])==false
    @test compare([],[3])==true
    @test compare([[[]]],[[]])==false
    @test compare([1,[2,[3,[4,[5,6,7]]]],8,9],[1,[2,[3,[4,[5,6,0]]]],8,9])==false#
end

@testset "example" begin
    file=open("example.txt","r")
    out::String=read(file,String)
    #@test solve(out)==13 
end

