import Base.show
using Test
include(joinpath(@__DIR__, "..", "phase3", "node.jl"))
include(joinpath(@__DIR__, "..", "phase1", "edge.jl"))
include(joinpath(@__DIR__, "..", "phase1", "graph.jl"))
include(joinpath(@__DIR__, "..", "phase1", "read_stsp.jl"))
include(joinpath(@__DIR__, "..", "phase2", "arbreRecouvrement.jl"))
include(joinpath(@__DIR__, "PriorityQueue.jl"))

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
    File = PriorityQueue()
    println(File)
end
