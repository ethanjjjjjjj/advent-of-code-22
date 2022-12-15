f=open("input.txt","r")

lines=read(f,String)

for index = 1:length(lines)-3
    chars=split(lines[index:index+3],"")
    chars=Set(chars)
    if length(chars)==4
        println(index+3)
        break
    end
end

close(f)