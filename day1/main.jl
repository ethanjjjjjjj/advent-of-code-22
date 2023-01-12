f=open("input.txt","r")
lines=read(f,String)

function solve(lines::String)
    return eachmatch(r"((\d+\n)+)",lines) .|> (sum∘(x->parse.(Int32,x))∘split∘(x->x.match)) |> (x->sort(x,rev=true)) |> (x->(x[1],sum(x[1:3])))
end

display(solve())