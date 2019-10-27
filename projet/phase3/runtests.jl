import Base.show
using Test
include(joinpath(@__DIR__, "..", "phase3", "node.jl"))
include(joinpath(@__DIR__, "..", "phase1", "edge.jl"))
include(joinpath(@__DIR__, "..", "phase1", "graph.jl"))
include(joinpath(@__DIR__, "..", "phase1", "read_stsp.jl"))
include(joinpath(@__DIR__, "..", "phase2", "arbreRecouvrement.jl"))

include(joinpath(@__DIR__, "kruskal.jl"))
include(joinpath(@__DIR__, "queue.jl"))
include(joinpath(@__DIR__, "prim.jl"))

@testset "Compression" begin
    node1 = Node(1,2)
    node2 = Node(2,1)
    node3 = Node(3,1)
    node4 = Node(4,1)
    edge1 = Edge(node4, node2, 2)
    edge2 = Edge(node2, node3, 1)
    edge4 = Edge(node1, node4, 1)
    arbre = Arbre("test", Dict(node3 => node3, node1 => node4, node2 => node3, node4 => node3), [edge2, edge4, edge1])
    node3.rang = 2
    compression!(arbre, node4, node3)
    @test getParent(arbre, node1) == node3
    @test getParent(arbre, node4) == node3
    @test node3.rang == 1
end

@testset "Union" begin
    node1 = Node(1,2)
    node2 = Node(2,1)
    node3 = Node(3,1)
    node4 = Node(4,1)
    edge1 = Edge(node4, node2, 2)
    edge2 = Edge(node2, node3, 1)
    edge4 = Edge(node1, node4, 1)
    arbre = Arbre("test", Dict(node3 => node3, node1 => node1, node2 => node3, node4 => node4), [edge2])

end

@testset "PriorityQueue" begin
    node1 = Node(1,2)
    node2 = Node(2,1)
    node3 = Node(3,1)
    node4 = Node(4,1)
    edge1 = Edge(node4, node2, 2)
    edge2 = Edge(node2, node3, 1)
    edge4 = Edge(node1, node4, 1)
    #ne reconnait pas la fonction PriorityQueue implémentée pour une raison que je ne comprend pas. Je suis donc obligée d'utiliser le constructeur classique.
    T = Array{Node{Int},1}()
    File = PriorityQueue(T)

    push!(File, node1)
    @test length(File) == 1
    push!(File, node2)
    @test File.nodes[2] == node2
    setWeight(node1, 5, node2)
    @test popfirst!(File) == node1
    @test length(File) == 1

end

@testset "arbrePrim.jl" begin
    node1 = Node(1,2)
    node2 = Node(2,1)
    node3 = Node(3,1)
    node4 = Node(4,1)
    edge1 = Edge(node4, node2, 2)
    edge2 = Edge(node2, node3, 1)
    edge3 = Edge(node1, node3, 3)
    edge4 = Edge(node1, node4, 1)
    file = PriorityQueue([node2, node3, node4])
    edges1 = [edge3, edge4]
    graphe = Graph("test", [node1, node2, node3, node4], [edge1, edge3, edge2, edge4])
    # Test initGraphPrim

    prim =  initGraphPrim(graphe)
    # penser à test qui marche pour tout @test getNodes(prim) == [node2, node1, node3, node4]
    @test length(getEdges(prim)) == 0
    @test getEdgesOfNode(prim, node1) == [edge3, edge4]

    # test majPoidsNoeud!
    file = getNodes(getQueue(prim))
    deleteat!(file, findall(x -> isequal(x, node1), file))
    majPoidsNoeud!(prim, node1)

    @test minWeight(node3) == 3
    @test minWeight(node4) == 1
    @test minWeight(node2) == Inf

    #test add_edge!
    add_edge!(prim, node3)
    @test getEdges(prim) == [edge3]
    @test getWeight(prim) == 3

end

@testset "prim.jl" begin
    node1 = Node(1,2)
    node2 = Node(2,1)
    node3 = Node(3,1)
    node4 = Node(4,1)
    edge1 = Edge(node4, node2, 2)
    edge2 = Edge(node2, node3, 1)
    edge3 = Edge(node1, node3, 3)
    edge4 = Edge(node1, node4, 1)
    graphe = Graph("test", [node1, node2, node3, node4], [edge1, edge3, edge2, edge4])
    arbre = prim(graphe, node1)
    @test getWeight(arbre) == 4
    @test getEdges(arbre) == [edge4, edge1, edge2]
    @test length(getQueue(arbre)) == 0

end
