f=open("input.txt","r")

mutable struct Monkey
    id::Int32
    items::Vector{Int32}
    operation::String
    test::Int32
    ifT::Int32
    ifF::Int32
    inspects::Int32
end

lines=read(f,String)
monkeyslist=split(lines,"\n\n")



monkeys::Vector{Monkey}=[]

for monkey in monkeyslist
    monkeynum=match(r"Monkey (\d+)",monkey)[1]

    starting=match(r"Starting items: (( ?\d+,?)+)",monkey)[1]
    startinglist=split(starting,", ")

    operation=match(r"Operation: new = (.+)\n",monkey)[1]
    test=match(r"Test: divisible by (\d+)",monkey)[1]
    ifT=match(r"If true: throw to monkey (\d+)",monkey)[1]
    ifF=match(r"If false: throw to monkey (\d+)",monkey)[1]
    monkeynum=parse(Int32,monkeynum)
    startinglist=parse.(Int32,startinglist)
    test=parse(Int32,test)
    ifT=parse.(Int32,ifT)
    ifF=parse.(Int32,ifF)
    push!(monkeys,Monkey(monkeynum,startinglist,operation,test,ifT,ifF,0))

end


for i=1:20
for monkey in monkeys
    while !isempty(monkey.items)
        item=popfirst!(monkey.items)
        old=item
        operation=replace(monkey.operation,"old"=>old)
        new=eval(Meta.parse(operation))
        new=floor(Int32,new/3)
        monkey.inspects+=1
        if new % monkey.test==0
            push!(monkeys[monkey.ifT+1].items,new)
        else
            push!(monkeys[monkey.ifF+1].items,new)
        end
    end
end
end
inspects=[x.inspects for x in monkeys]
sort!(inspects)
reverse!(inspects)
println(prod(inspects[1:2]))