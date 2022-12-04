f=open("input.txt","r")
lines=read(f,String)
close(f)
sums=eachmatch(r"(((\d)+\n)+)",lines) |> 
    collect .|> (x->x.match) .|> 
    split .|> (x->parse.(Int64,x)) .|> 
    sum |> x->sort(x,rev=true)
display(sums[1:3])