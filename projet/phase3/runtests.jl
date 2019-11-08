using Test
include(joinpath(@__DIR__, "..", "phase3", "node.jl"))
include(joinpath(@__DIR__, "..", "phase1", "edge.jl"))
include(joinpath(@__DIR__, "..", "phase1", "graph.jl"))
include(joinpath(@__DIR__, "..", "phase1", "read_stsp.jl"))
include(joinpath(@__DIR__, "..", "phase2", "arbreRecouvrement.jl"))
include(joinpath(@__DIR__, "queue.jl"))
include(joinpath(@__DIR__, "main.jl"))
#=
@testset "Compression" begin
    #=
        1----4
             |
        3----2
    =#
    node1 = Node(1,2)
    node2 = Node(2,1)
    node3 = Node(3,1)
    node4 = Node(4,1)
    edge1 = Edge(node4, node2, 2)
    edge2 = Edge(node2, node3, 1)
    edge4 = Edge(node1, node4, 1)
    arbre = Kruskal("test", Dict(node3 => node3, node1 => node4, node2 => node3, node4 => node3), [edge2, edge4, edge1])
    node3.rang = 2
    compression!(arbre, node4, node3)
    @test getParent(arbre, node1) == node3
    @test getParent(arbre, node4) == node3
    @test node3.rang == 1
end

@testset "Union" begin
    #=
        1---4
          / |
        3---2
    =#
    node1 = Node(1,2)
    node2 = Node(2,1)
    node3 = Node(3,1)
    node4 = Node(4,1)
    edge1 = Edge(node4, node2, 2)
    edge2 = Edge(node2, node3, 1)
    edge3 = Edge(node3, node4, 2)
    edge4 = Edge(node1, node4, 1)
    arbre = Kruskal("test", Dict(node3 => node3, node1 => node1, node2 => node2, node4 => node4), [edge2])

    # Test si elles ont le même rang
    poids = union!(edge4, arbre)
    @test getParent(arbre, node1) == node4
    #@test poids == 1
    @test edges(arbre) == [edge2, edge4]

    # Test si racine1 est plus petite que racine2
    poids = union!(edge3, arbre)
    @test getParent(arbre, node3) == node4
    #@test poids == 3

    # Test si racine2 est plus petite ou égale que racine1
    poids = union!(edge1, arbre)
    @test getParent(arbre, node2) == node4
    #@test poids == 5

end =#

@testset "PriorityQueue" begin
    #=
        1----4
             |
        3----2
    =#
    node1 = Node(1,2)
    node2 = Node(2,1)
    node3 = Node(3,1)
    node4 = Node(4,1)
    edge1 = Edge(node4, node2, 2)
    edge2 = Edge(node2, node3, 1)
    edge3 = Edge(node2, node1, 1)
    edge4 = Edge(node1, node4, 1)
    #ne reconnait pas la fonction PriorityQueue implémentée pour une raison que je ne comprend pas. Je suis donc obligée d'utiliser le constructeur classique.
    File = PriorityQueue(Array{Node{Int},1}(), Array{Union{Nothing, Edge{Int}},1}())

    @test is_empty(File)
    push!(File, node1)
    @test length(File) == 1
    push!(File, node2, edge3)
    @test File.nodes[2] == node2
    @test getEdges(File) == [nothing,edge3]
    node, edge = popfirst!(File)
    @test  node == node2
    @test edge == edge3
    @test length(File) == 1
    @test getWeight(File, node1) == Inf

end

@testset "arbrePrim.jl" begin
    #=
        1----4
        |    |
        3----2
    =#
    node1 = Node(1,2)
    node2 = Node(2,1)
    node3 = Node(3,1)
    node4 = Node(4,1)
    edge1 = Edge(node4, node2, 2)
    edge2 = Edge(node2, node3, 1)
    edge3 = Edge(node1, node3, 3)
    edge4 = Edge(node1, node4, 1)
    File = PriorityQueue(Array{Node{Int},1}(), Array{Union{Nothing, Edge{Int}},1}())
    push!(File, node2)
    push!(File, node3)
    push!(File, node4)
    edges1 = [edge3, edge4]
    graphe = Graph("test", [node1, node2, node3, node4], [edge1, edge3, edge2, edge4])

    # Test initGraphPrim
    prim =  initGraphPrim(graphe)
    # Tous les noeuds sont présents dans le dictionnaire de noeuds du graphe.
    @test length(getNodes(prim)) == 4
    t = [node2, node1, node3, node4]
    for node in getNodes(prim)
        @test !isa(findall(x -> x == node, t), Nothing)
    end

    # Les arêtes associées à un noeud sont présentes dans le dictionnaire
    @test getEdgesOfNode(prim, node1) == [edge3, edge4]

    # Il n'y a pas encore d'arêtes dans l'arbre de recouvrement minimal
    @test length(getEdges(prim)) == 0
    @test getEdge(prim, node1) == nothing

    # test majPoidsNoeud!
    file = getNodes(getQueue(prim))
    deleteat!(file, findall(x -> isequal(x, node1), file))
    majPoidsNoeud!(prim, node1)
    @test minWeight(prim, node3) == 3
    @test minWeight(prim, node4) == 1
    @test minWeight(prim, node2) == Inf

    push!(prim, edge3)
    @test getEdges(prim) == [edge3]
    @test getWeight(prim) == 3



end

@testset "prim" begin
    #=
        1----4
        |    |
        3----2
    =#
    node1 = Node(1,2)
    node2 = Node(2,1)
    node3 = Node(3,1)
    node4 = Node(4,1)
    edge1 = Edge(node4, node2, 2)
    edge2 = Edge(node2, node3, 1)
    edge3 = Edge(node1, node3, 3)
    edge4 = Edge(node1, node4, 1)
    graphe = Graph("test", [node1, node2, node3, node4], [edge1, edge3, edge2, edge4])

    # Test de la fonction prim
    graphePrim = prim(graphe)
    @test getWeight(graphePrim) == 4

    # Toutes les arêtes de l'arbre de recouvrement minimal sont présentes.
    @test length(getEdges(graphePrim)) == 3
    t = [edge4, edge1, edge2]
    for edge in getEdges(graphePrim)
        @test !isa(findall(x -> x == edge, t), Nothing)
    end

    # Il ne reste plus de noeuds à ajouter.
    @test is_empty(getQueue(graphePrim))

end
#=
@testset "exemple cours" begin
    # Test sur l'arbre vu en cours
    # Construction des noeuds
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

    grapheCours = Graph("cours", nodes, edges)
    grapheKruskal = kruskal(grapheCours)
    t = [edge1, edge2, edge3, edge5, edge6, edge7, edge8, edge12, edge14]
    @test length(getEdges(grapheKruskal)) == 8
    for edge in getEdges(grapheKruskal)
        @test !isa(findall(x -> x == edge, t), Nothing)
    end


    graphePrim = prim!(grapheCours)
    @test getWeight(graphePrim) == 37
    t = [edge1, edge2, edge3, edge5, edge6, edge7, edge8, edge12, edge14]
    @test length(getEdges(graphePrim)) == 8
    for edge in getEdges(graphePrim)
        @test !isa(findall(x -> x == edge, t), Nothing)
    end


end
=#
