import Base.show
import Base.popfirst!
import Base.sort!

"""Type abstrait dont d'autres files vont découler."""
abstract type AbstractPriorityQueue{T} end

""" Type représentant une file de priorité ordonnée par le poids minimal des noeuds.

  nodes: Array{Any, 3}
    Première colonne : noeuds en dehors de l'arbre de recouvrement minimal
    Deuxième colonne : index de l'arête de poids minimal dans son tableau associé

Exemple :
    node0 = Node(0,1, 0, 0)
    node1 = Node(1,2, 0, 1)
    node2 = Node(2,1, 0, Inf)
    node3 = Node(3,1, 0, Inf)
    edge1 = Edge(node1, node2, 4)
    edge2 = Edge(node2, node3, 2)
    edge3 = Edge(node1, node3, 1)
    edge4 = Edge(node0, node1, 1)

    queue = (Array[(node1, 1)(node2, nothing), (node3, nothing)]
"""
mutable struct PriorityQueue{T} <: AbstractPriorityQueue{T}
  nodes::Array{Any, 2}
end


function PriorityQueue(queue::Array{Any, 2})
  sort!(queue, by = x -> x[1].minWeight )
  PriorityQueue(queue)
end

"""Renvoie le tableau de noeuds de la file de priorité."""
isolatedNodes(queue::AbstractPriorityQueue) = queue.nodes

"""Constructeur de file de priorité vide."""
PriorityQueue() = PriorityQueue(Array{Any}(undef ,0,2))

"""Ajoute un noeud dans la file de priorité."""
function push!(queue::PriorityQueue{T}, node::AbstractNode{T}, edge::AbstractEdge{T}) where T
  queue.nodes = vcat(queue.nodes, [node, edge])
  sort!(queue.nodes, by = x -> x[1].minWeight)
end

"""Renvoie le premier élément de la file de priorité."""
popfirst!(queue::PriorityQueue) = popfirst!(queue.nodes)

"""Réordonne les noeuds de la file d'attente par poids minimal."""
sort!(queue::PriorityQueue) = sort!(queue.nodes, by = x -> x[1].minWeight)
