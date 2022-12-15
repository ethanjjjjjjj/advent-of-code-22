using Pipe
f=open("input.txt","r")
lines= @pipe read(f,String) |>split(_,"\n")
count=0
for line in lines
    low1,high1,low2,high2= @pipe split(line,",") |>
                                 split.(_,"-") |>
                                 Iterators.flatten |>
                                 parse.(Int32,_)
    if (low2 <= high1 && high2 >=low1) || (low2 >= low1 && high2 <= high1)
        global count+=1
    end
end
println(count)