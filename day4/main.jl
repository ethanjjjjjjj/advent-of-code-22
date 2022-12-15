f=open("input.txt","r")

lines=read(f,String)

lines=split(lines,"\n")
count=0
for line in lines
    groups=split(line,",")
    matches=match(r"(\d+)-(\d+)",groups[1])
    low1=parse(Int32,matches[1])
    high1=parse(Int32,matches[2])
   
    matches=match(r"(\d+)-(\d+)",groups[2])
    low2=parse(Int32,matches[1])
    high2=parse(Int32,matches[2])
    if (low1<=low2 && high1>=high2) || (low2<=low1 && high2>=high1)
        global count+=1
    end
end
println(count)