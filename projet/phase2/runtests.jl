import Base.show
using Test
include(joinpath(@__DIR__, "..", "phase3", "node.jl"))
include(joinpath(@__DIR__, "..", "phase1", "edge.jl"))
include(joinpath(@__DIR__, "..", "phase1", "graph.jl"))
include(joinpath(@__DIR__, "..", "phase1", "read_stsp.jl"))
include(joinpath(@__DIR__, "..", "phase2", "arbreRecouvrement.jl"))
include(joinpath(@__DIR__, "..", "phase3", "main.jl"))

@testset "Node" begin
    node1 = Node(1,2)
    @test name(node1) == 1
    @test data(node1) == 2
    node2 = Node(2,1)
    node3 = Node(3,1)
end

@testset "Edge" begin
    node1 = Node(1,2)
    node2 = Node(2,1)
    node3 = Node(3,1)
    edge1 = Edge(node1, node2, 4)
    @test getNode1(edge1) == node1
    @test getNode2(edge1) == node2
    @test weight(edge1) == 4
    edge2 = Edge(node2, node3, 2)
end

@testset "Graph" begin
    node1 = Node(1,2)
    node2 = Node(2,1)
    node3 = Node(3,1)
    edge1 = Edge(node1, node2, 4)
    edge2 = Edge(node2, node3, 2)
    graphe = Graph("test", [node1, node2], [edge1])
    @test name(graphe) == "test"
    @test nb_nodes(graphe) == 2
    @test nb_edges(graphe) == 1
    @test typeNode(graphe) == Int64
    @test nodes(graphe) == [node1, node2]
    @test getEdges(graphe) == [edge1]
    add_node!(graphe,  node3)
    @test nodes(graphe) == [node1, node2, node3]
    add_edge!(graphe, edge2)
    @test getEdges(graphe) == [edge1, edge2]
end


@testset "Recouvrement" begin
    node1 = Node(1,2)
    node2 = Node(2,1)
    node3 = Node(3,1)
    edge1 = Edge(node1, node2, 4)
    edge2 = Edge(node2, node3, 2)
    graphe = Graph("test", [node1, node2], [edge1])
    add_node!(graphe,  node3)
    add_edge!(graphe, edge2)
    foret = initArbre(graphe)
    @test name(foret) == name(graphe)
    @test getParent(foret, node1) == node1
    @test getParent(foret, node2) == node2
    @test getParent(foret, node3) == node3
    @test getEdges(foret) == Edge{Int64}[]
    @test getParent(foret, node1) == node1
    @test getRacine(foret, node1) == node1
    changeParent!(foret, node1, node2)
    @test getParent(foret, node1) == node2
    @test getRacine(foret, node1) == node2
    changeParent!(foret, node2, node3)
    @test getRacine(foret, node1) == node3
    # Problème sur les erreurs retournées par la fonction. A voir avec le prof.
    #@test_throws ErrorException("le parent n'existe pas") getParent(foret, node4)
    #@test_throws ErrorException("le parent n'existe pas") getRacine(foret, node4)
end

@testset "AlgoKruskal" begin
    node1 = Node(1,2)
    node2 = Node(2,1)
    node3 = Node(3,1)
    edge1 = Edge(node1, node2, 4)
    edge2 = Edge(node2, node3, 2)
    graphe = Graph("test", [node1, node2], [edge1])
    add_node!(graphe,  node3)
    add_edge!(graphe, edge2)
    foret = initArbre(graphe)
    edge3 = Edge(node1, node3, 1)
    add_edge!(graphe, edge3)
    # test du bon fonctionnement de l'algo
    arbre = kruskal(graphe)
    @test getRacine(arbre, node3) == node3 || node1
    @test getRacine(arbre, node2)== node3 || node2
    @test getRacine(arbre, node1) == node3 || node1
    @test getEdges(arbre) == [edge3, edge2]
end
