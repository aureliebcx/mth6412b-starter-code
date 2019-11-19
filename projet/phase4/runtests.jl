using Test
include(joinpath(@__DIR__, "..", "phase4", "RSL.jl"))
include(joinpath(@__DIR__, "..", "phase4", "HK.jl"))
include(joinpath(@__DIR__, "..", "phase1", "read_stsp.jl"))


@testset "fonctions simples ajoutées" begin
    node1 = Node(1,2)
    node2 = Node(2,1)
    node3 = Node(3,1)
    node4 = Node(4,3)
    @test isequal(node1, node1)
    @test !isequal(node1, node2)

    edge1 = Edge(node1, node2, 2)
    edge2 = Edge(node2, node3, 1)
    edge3 = Edge(node2, node4, 4)
    edge4 = Edge(node1, node4, 5)
    # edge.jl
    @test isless(edge2, edge1)
    @test isequal(edge1, edge1)
    @test !isequal(edge1, edge2)
    setWeight(edge3, 5)
    @test weight(edge3) == 5

    # graph.jl
    graphe = Graph("test", [node1, node2, node3], [edge1, edge2])
    delete_node!(graphe, node1)
    @test getNodes(graphe) == [node2, node3]
    @test getEdges(graphe) == [edge2]
    @test isequal(find_edge(node1, node2, [edge1, edge2]), edge1)

    # arbrePrim.jl
    graphe = Graph("test", [node1, node2, node3], [edge1, edge2])
    graphe_prim = prim(graphe, node1)
    @test length(getNodes(graphe_prim)) == 3
    add_node!(graphe_prim, node4, [edge4])
    @test length(getNodes(graphe_prim)) == 4
    @test getEdgesOfNode(graphe_prim, node4) == [edge4]
    pushfirst!(graphe_prim, edge3)
    @test getEdges(graphe_prim) == [edge3, edge1, edge2]

    # HK.jl
    @test edges_min!([edge1, edge2, edge3]) == (edge2, edge1)
    @test gradient(Graph("test", [node1, node2, node3, node4], [edge1, edge2, edge3]), node1) == -1
    @test gradient(Graph("test", [node1, node2, node3, node4], [edge1, edge2, edge3]), node2) == 1

    getRealWeight(graphe, [edge1, edge3, edge2, edge4])
end


@testset "Tournee" begin
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

    graphePrim = initTournee(graphe, node1, true)
    @test getArbre(graphePrim) == graphePrim.arbre
    @test getEdges(graphePrim) == graphe.edges
    @test length(getNodes(graphePrim)) == 4
    for node in getNodes(graphePrim)
        @test node in [node1, node2, node3, node4]
    end

    @test getVisited(graphePrim, node1) == false
    setVisited(graphePrim, node1, true)
    @test getVisited(graphePrim, node1) == true

    pushfirst!(graphePrim, edge5)
    @test isequal(getEdges(getTournee(graphePrim))[1], edge5)

    add_edge!(graphePrim, edge6)
    @test isequal(getEdges(getTournee(graphePrim))[2], edge6)

end


@testset "RSL" begin

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
    graphe = Graph("test", [node1, node2, node3, node4], [edge1, edge3, edge2, edge4, edge5, edge6])

    #= arbre
        1----4
             |
        3----2
    =#

    tournee = initTournee(graphe, node1, true)
    ordre1 = parcours_pre!(tournee, node1)
    @test getEdges(getTournee(ordre1)) ==  [edge4, edge1, edge2, edge3]

    tournee = initTournee(graphe, node1, true)
    ordre2 = parcours_pre!(tournee, node2)
    @test (getEdges(getTournee(ordre2)) == [edge2, edge6, edge4, edge5]) || getEdges(getTournee(ordre2)) == [edge1, edge4, edge3, edge2]

end


@testset " test stsp" begin
    name = "bayg29.tsp"
    grapheCours = construct_graph(name, "test")

    rsl = RSL(grapheCours, getNodes(grapheCours)[7], false)
    @test length(getEdges(getTournee(rsl))) == length(getNodes(grapheCours))
    # plot_tournee(getNodes(getArbre(rsl)), getEdges(getArbre(rsl)))
    # plot_tournee(getNodes(rsl), getEdges(getTournee(rsl)))
    println(getWeight(rsl))

end


@testset "HK.jl" begin

    #= graphe
        1-----4
        |  X  |
        3-----2
    =#

    node1 = Node(1,[1,1])
    node2 = Node(2,[2,1])
    node3 = Node(3,[1,2])
    node4 = Node(4,[2,3])
    node5 = Node(5,[3,2])
    edge1 = Edge(node4, node2, 20)
    edge2 = Edge(node2, node3, 14)
    edge3 = Edge(node1, node3, 10)
    edge4 = Edge(node1, node4, 22)
    edge5 = Edge(node1, node2, 10)
    edge7 = Edge(node1, node5, 22)
    edge6 = Edge(node3, node4, 14)
    edge8 = Edge(node2, node5, 14)
    edge9 = Edge(node4, node5, 14)
    edge10 = Edge(node3, node5, 20)
    graphe = Graph("test", [node1, node2, node3, node4, node5], [edge1, edge2, edge3, edge4, edge5, edge6, edge7, edge8, edge9, edge10])

    #= tournee = HK(graphe, 50, 1)
    @test length(getNodes(tournee)) == 4 # un noeud de moins car l'arbre de recouvrement de tournee n'a pas la racine choisie par l'utilisateur
    @test length(collect(keys(tournee.visited))) == 5
    println(getWeight(tournee))
    plot_tournee(getNodes(getTournee(tournee)), getEdges(getTournee(tournee))) =#
    #= graphe = construct_graph("brazil58.tsp", "test")
     hk = HK(graphe, 100, 5)
     @test length(hk.tournee.edges) == length(getNodes(hk)) + 1 =#
    # plot_tournee(getNodes(hk), getEdges(getTournee(hk)))



end
