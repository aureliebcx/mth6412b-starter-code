using Test
include(joinpath(@__DIR__, "..", "phase4", "RSL.jl"))
include(joinpath(@__DIR__, "..", "phase1", "read_stsp.jl"))

@testset "isequal, find_edge, delete_node!" begin
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

    graphe = Graph("test", [node1, node2, node3], [edge1, edge2])
    delete_node!(graphe, node1)
    @test getNodes(graphe) == [node2, node3]
    @test getEdges(graphe) == [edge2]
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

    graphePrim = initRSL(graphe, node1)
    @test getArbre(graphePrim) == graphePrim.arbre
    @test getEdges(graphePrim) == graphe.edges
    @test length(getNodes(graphePrim)) == 4
    for node in getNodes(graphePrim)
        @test node in [node1, node2, node3, node4]
    end

    @test getVisited(graphePrim, node1) == false
    setVisited(graphePrim, node1, true)
    @test getVisited(graphePrim, node1) == true

end

#=
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

    graphePrim = prim(graphe)

    ordre1 = parcours_pre(graphePrim, node1)
    @test ordre1 ==  [node1, node4, node2, node3, node1]

    ordre2 = parcours_pre(graphePrim, node2)
    @test ordre2 == [node2, node3, node4, node1, node2] ||  [node2, node4, node1, node3, node2]

end
=#
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
    #=
    println("le noeud de départ est : ", rsl_1.arbre.firstNode)
    for edge in getEdges(getArbre(rsl_1))
        show(edge)
    end
    println("les arêtes de la tournée : ")
    for edge in  getEdges(getTournee(rsl_1))
        show(edge)
    end =#
    @test length(getEdges(getTournee(rsl_1))) == 4
    noeudDepart = getFirstNode(getArbre(rsl_1))
    #plot_tournee(getNodes(graphe), getEdges(getTournee(rsl_1)))
    rsl_2 = RSL(graphe, node2)
    # @test getEdges(getTournee(rsl_2)) == ([edge2, edge6, edge4, edge5] || [edge1, edge4, edge3, edge2])
    #plot_tournee(getNodes(graphe), getEdges(getTournee(rsl_2)))

end



@testset "exemple cours" begin
    name = "bays29.tsp"
    grapheCours = construct_graph(name, "test")


    rsl = RSL(grapheCours, getNodes(grapheCours)[16])
    plot_tournee(getNodes(getArbre(rsl)), getEdges(getArbre(rsl)))
    # plot_tournee(getNodes(rsl), getEdges(getTournee(rsl)))
    println(getWeight(rsl))

end
