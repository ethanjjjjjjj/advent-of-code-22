f=open("input.txt")
lines=read(f,String)

lines=split(lines,"\n")

function solve()
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
        
        
    end
    return sum
end

display(solve())