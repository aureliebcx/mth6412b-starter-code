using Test
include(joinpath(@__DIR__, "..", "phase3", "main.jl"))
include(joinpath(@__DIR__, "..", "phase4", "RSL.jl"))

include(joinpath(@__DIR__, "..", "phase1", "read_stsp.jl"))

@testset "isequal and find_edge" begin
    node1 = Node(1,2)
    node2 = Node(2,1)
    node3 = Node(3,1)
    @test isequal(node1, node1)
    @test !isequal(node1, node2)

    edge1 = Edge(node1, node2, 2)
    edge2 = Edge(node2, node3, 1)

    @test isequal(edge1, edge1)
    @test !isequal(edge1, edge2)

    @test isequal(find_edge(node1, node2, [edge1, edge2]), edge1)
end

@testset "parcours pré-ordre" begin
    #= graphe
        1----4
        |    |
        3----2
    =#
    node1 = Node(1,[0,1])
    node2 = Node(2,[1,1])
    node3 = Node(3,[0,0])
    node4 = Node(4,[1,1])
    edge1 = Edge(node4, node2, 2)
    edge2 = Edge(node2, node3, 1)
    edge3 = Edge(node1, node3, 3)
    edge4 = Edge(node1, node4, 1)
    edge5 = Edge(node1, node2, 5)
    edge6 = Edge(node3, node4, 5)
    graphe = Graph("test", [node1, node2, node3, node4], [edge1, edge3, edge2, edge4])

    #= arbre
        1----4
             |
        3----2
    =#

    arbre = prim!(graphe)

    ordre1 = parcours_pre(arbre, node1)
    @test ordre1 ==  [node1, node4, node2, node3, node1]

    ordre2 = parcours_pre(arbre, node2)
    @test ordre2 == [node2, node3, node4, node1, node2] ||  [node2, node4, node1, node3, node2]

@testset "RSL" begin
    #= graphe
        1-----4
        |  X  |
        3-----2
    =#
    node1 = Node(1,[1,2])
    node2 = Node(2,[2,1])
    node3 = Node(3,[1,1])
    node4 = Node(4,[2,2])
    edge1 = Edge(node4, node2, 2)
    edge2 = Edge(node2, node3, 1)
    edge3 = Edge(node1, node3, 3)
    edge4 = Edge(node1, node4, 1)
    edge5 = Edge(node1, node2, 5)
    edge6 = Edge(node3, node4, 5)
    graphe = Graph("test", [node1, node2, node3, node4], [edge1, edge3, edge2, edge4, edge5, edge6])

    rsl_1 = RSL(graphe, node1)
    @test rsl_1 == [edge4, edge1, edge2, edge3]
    plot_tournee(graphe.nodes, rsl_1)
    rsl_2 = RSL(graphe, node2)
    @test rsl_2 == [edge2, edge6, edge4, edge5] || [edge1, edge4, edge3, edge2]
end


end

@testset "exemple cours" begin
    node1 = Node(1, "a")
    node2 = Node(2, "b")
    node3 = Node(3, "C")
    node4 = Node(4, "d")
    node5 = Node(5, "e")
    node6 = Node(6, "f")
    node7 = Node(7, "g")
    node8 = Node(8, "h")
    node9 = Node(9, "i")
    nodes = [node1, node2, node3, node4, node5, node6, node7, node8, node9]

    # Construction des arêtes
    edge1 = Edge(node1, node2, 4)
    edge2 = Edge(node1, node8, 8)
    edge3 = Edge(node2, node3, 8)
    edge4 = Edge(node2, node8, 11)
    edge5 = Edge(node3, node9, 2)
    edge6 = Edge(node3, node6, 4)
    edge7 = Edge(node3, node4, 7)
    edge8 = Edge(node4, node5, 9)
    edge9 = Edge(node4, node6, 14)
    edge10 = Edge(node5, node6, 10)
    edge11 = Edge(node7, node9, 6)
    edge12 = Edge(node7, node8, 1)
    edge13 = Edge(node8, node9, 7)
    edge14 = Edge(node6, node7, 2)
    edges = [edge1, edge2, edge3, edge4, edge5, edge6, edge7, edge8, edge9, edge10, edge11, edge12, edge13, edge14]

    edge = find_edge(node1, node2, edges)
    @test isequal(edge1, edge)

    grapheCours = Graph("cours", nodes, edges)
    graphKruskal = kruskal(grapheCours)
    graphPrim = prim!(grapheCours)

    ordre = parcours_pre(graphPrim, node9)

end
