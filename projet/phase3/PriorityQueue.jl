import Base.show
import Base.popfirst!
import Base.push!
import Base.sort!

"""Type abstrait dont d'autres files vont découler."""
abstract type AbstractQueue end

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
mutable struct PriorityQueue <: AbstractQueue
  nodes::Vector{Node}
end

"""Renvoie le tableau de noeuds de la file de priorité."""
getNodes(queue::AbstractQueue) = queue.nodes

"""Constructeur de file de priorité vide."""
PriorityQueue()= PriorityQueue(Array())

"""Ajoute un noeud dans la file de priorité."""
#push!(queue::PriorityQueue, node::AbstractNode)  = push!(queue.nodes, node)
function push!(queue::PriorityQueue, node::AbstractNode
  a =Array{Node, 1}(node)
  queue.nodes = cat(queue.nodes, a)
end

"""Renvoie le premier élément de la file de priorité."""
function popfirst!(queue::PriorityQueue)
  nodes = getNodes(queue)
  index = nothing
  if(length(nodes) == 0)
    return nothing
  else
    minWeight = minWeight(nodes[1])
    index = 1
    if(length(nodes) > 1)
      for i in 2:length(nodes)
        temp = minWeight(nodes[i])
        if(temp <= minWeight)
          minWeight = temp
          index = i
        end
      end
    end
    return deleteat!(queue.nodes, index)
  end

end
