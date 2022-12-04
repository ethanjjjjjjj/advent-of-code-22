open("input.txt","r") do f
eachmatch(r"((\d+\n)+)",read(f,String)) .|> (sum∘(x->parse.(Int32,x))∘split∘(x->x.match)) |> (x->sort(x,rev=true)) |> (x->(x[1],sum(x[1:3]))) |> display
end
