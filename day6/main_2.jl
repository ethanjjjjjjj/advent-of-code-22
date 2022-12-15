f=open("input.txt","r")

lines=read(f,String)
for index = 1:length(lines)-13
    chars=split(lines[index:index+13],"")
    chars=Set(chars)
    if length(chars)==14
        println(index+13)
        break
    end
end

close(f)