f=open("input.txt")
lines=read(f,String)


lines="addx 15
addx -11
addx 6
addx -3
addx 5
addx -1
addx -8
addx 13
addx 4
noop
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx 5
addx -1
addx -35
addx 1
addx 24
addx -19
addx 1
addx 16
addx -11
noop
noop
addx 21
addx -15
noop
noop
addx -3
addx 9
addx 1
addx -3
addx 8
addx 1
addx 5
noop
noop
noop
noop
noop
addx -36
noop
addx 1
addx 7
noop
noop
noop
addx 2
addx 6
noop
noop
noop
noop
noop
addx 1
noop
noop
addx 7
addx 1
noop
addx -13
addx 13
addx 7
noop
addx 1
addx -33
noop
noop
noop
addx 2
noop
noop
noop
addx 8
noop
addx -1
addx 2
addx 1
noop
addx 17
addx -9
addx 1
addx 1
addx -3
addx 11
noop
noop
addx 1
noop
addx 1
noop
noop
addx -13
addx -19
addx 1
addx 3
addx 26
addx -30
addx 12
addx -1
addx 3
addx 1
noop
noop
noop
addx -9
addx 18
addx 1
addx 2
noop
noop
addx 9
noop
noop
noop
addx -1
addx 2
addx -37
addx 1
addx 3
noop
addx 15
addx -21
addx 22
addx -6
addx 1
noop
addx 2
addx 1
noop
addx -10
noop
noop
addx 20
addx 1
addx 2
addx 2
addx -6
addx -11
noop
noop
noop"

lines=split(lines,"\n")




function solve()
    grid=fill(".",(6,40))
    cycles=Dict("addx"=>2,"noop"=>1)
    linesindex=1
    instructioncycle=1
    cycle=1
    register=1
    sum=0
    while linesindex <= length(lines)
        
        line=lines[linesindex]
        parsedline=match(r"(\S+) ?(-?\d*)",line)

        instruction=parsedline[1]
        operand = (parsedline[2] == "") ?  Nothing() : parse(Int32,parsedline[2])


        if instructioncycle < cycles[instruction]
            instructioncycle+=1
        else
            instructioncycle=1
            if instruction=="addx"
                register+=operand
            end
            linesindex+=1
        end
        #increment program counter for next instruction
        cycle+=1
        
        if (cycle-20)%40==0
            println(cycle," ",register)
            sum+=cycle*register
        end
        
        X=register
        validplaces=X.+[-1,0,1]
        println(cycle," ",validplaces)
        if cycle in validplaces
            grid[1,cycle]="#"
        end

        if cycle==40
            break
        end
    end
    display(grid)
    return sum

end

display(solve())