using AbstractTrees



mutable struct FileNode
    value::String
    size::Int32
    parent::Any
end

mutable struct DirNode
    value::String
    children::Vector{Union{DirNode,FileNode}}
    parent::Union{DirNode,Nothing}
end

AbstractTrees.children(n::Union{DirNode,FileNode})=n.children
AbstractTrees.nodevalue(n::Union{DirNode,FileNode}) = n.value
AbstractTrees.filesize(n::FileNode) = n.size
AbstractTrees.parent(n::Union{DirNode,FileNode}) = n.parent


function sizeNode(n::Union{DirNode,FileNode})

    size=0

    if typeof(n)==FileNode
        size=n.size
    else
        for child in n.children
            size+=sizeNode(child)
        end
    end
    return size

end


function dfs(n::DirNode)::Vector{DirNode}
    dirs=[]

    for node in n.children
        if typeof(node)==DirNode
            dirs=vcat(dirs,dfs(node))
            
        end
    end
    dirs=vcat(dirs,n)
    return dirs
end





tree=DirNode("/",[],Nothing())
f=open("input.txt","r")

lines=read(f,String)



lines=split(lines,"\n")

currentNode=tree

for line in lines
    cd=match(r"\$ cd (\S+)",line)
    ls=match(r"\$ ls",line)
    files=match(r"(\d+) (\S+)",line)
    dirs=match(r"dir (\S+)",line)

    if cd!==nothing
        cdto=cd[1]
        if cdto==".." && currentNode.parent!=Nothing()
            global currentNode=currentNode.parent
        else
            for directory in currentNode.children
                if typeof(directory)==DirNode && directory.value==cdto
                    currentNode=directory
                    break
                end
            end
        end
    elseif ls!==nothing
        continue
    elseif files!==nothing
        push!(currentNode.children,FileNode(files[2],parse(Int32,files[1]),currentNode))
    elseif dirs!==nothing
        creatednode=DirNode(dirs[1],[],currentNode)
        if creatednode in currentNode.children
            continue
        else
        push!(currentNode.children,creatednode)
        end
    end
end


total=0
for dir in dfs(tree)
    nodesize=sizeNode(dir)
    if nodesize<=100000
        global total+=nodesize
    end
end

println(total)