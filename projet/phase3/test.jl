import Base.show
include(joinpath(@__DIR__, "..", "phase3", "node.jl"))
include(joinpath(@__DIR__, "..", "phase1", "edge.jl"))
include(joinpath(@__DIR__, "..", "phase1", "graph.jl"))
include(joinpath(@__DIR__, "..", "phase1", "read_stsp.jl"))
include(joinpath(@__DIR__, "..", "phase2", "arbreRecouvrement.jl"))
include(joinpath(@__DIR__, "kruskal.jl"))
include(joinpath(@__DIR__, "queue.jl"))

node1 = Node(1,2)
node2 = Node(2,1)
node3 = Node(3,1)
node4 = Node(4,1)
edge1 = Edge(node4, node2, 2)
edge2 = Edge(node2, node3, 1)
edge3 = Edge(node1, node3, 3)
edge4 = Edge(node1, node4, 1)
graphe = Graph("test", [node1, node2, node3, node4], [edge1, edge3, edge2, edge4])
arbre = Arbre("test", Dict(node3 => node3, node1 => node4, node2 => node3, node4 => node3), [edge2, edge4, edge1])
node3.rang = 2
println("test1")
println(getParent(arbre, node1))
compression!(arbre, node4, node3)
println(getParent(arbre, node1))
println(node3.rang)

file = PriorityQueue([node1, node2])
