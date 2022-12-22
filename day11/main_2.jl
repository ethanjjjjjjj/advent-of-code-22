
using Pipe

#monkey struct
mutable struct Monkey
    id::Int64
    items::Vector{Int64}
    operation
    test::Int64
    ifT::Int64
    ifF::Int64
    inspects::Int64
end

f=open("input.txt","r")
lines=read(f,String)
monkeyslist=split(lines,"\n\n")

monkeys::Vector{Monkey}=[]
testvalues::Vector{Int32}=[]
        
#extract info from file
for monkey in monkeyslist

    #extract strings
    monkeynum=match(r"Monkey (\d+)",monkey)[1]
    starting=match(r"Starting items: (( ?\d+,?)+)",monkey)[1]
    operation=match(r"Operation: new = (.+)\n",monkey)[1]
    test=match(r"Test: divisible by (\d+)",monkey)[1]
    ifT=match(r"If true: throw to monkey (\d+)",monkey)[1]
    ifF=match(r"If false: throw to monkey (\d+)",monkey)[1]

    #parse strings
    startinglist=split(starting,", ")
    monkeynum=parse(Int64,monkeynum)
    startinglist=parse.(Int64,startinglist)
    test=parse(Int64,test)
    ifT=parse.(Int64,ifT)
    ifF=parse.(Int64,ifF)

    operation="old -> "*operation
    operation=Meta.parse(operation)
    operation=eval(operation)
    

    #push values to lists
    push!(monkeys,Monkey(monkeynum,startinglist,operation,test,ifT,ifF,0))
    push!(testvalues,test)
end


#calculate value to mod by which will not affect divisibility of any number by and of the tests
reduction = prod(testvalues)


function round(monkeys::Vector{Monkey})
    for monkey in monkeys
        while !isempty(monkey.items)
            new= popfirst!(monkey.items)
            new= monkey.operation(new) 
            
            new=new%reduction
            monkey.inspects+=1
            pushmonkey = (new % monkey.test==0) ? monkeys[monkey.ifT+1].items : monkeys[monkey.ifF+1].items
            push!(pushmonkey,new)
        end
    end
end


function solve()
    for i= 1:10000
        round(monkeys)
    end
    inspects=[x.inspects for x in monkeys]
    sort!(inspects)
    reverse!(inspects)
    return prod(inspects[1:2])
end


display(solve())