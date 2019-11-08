import Base.length, Base.push!, Base.popfirst!
import Base.show

"""Type abstrait dont d'autres types de files dériveront."""
abstract type AbstractQueue{T} end

"""File ayant un comportement de pile."""
mutable struct Stack{T} <: AbstractQueue{T}
  nodes::Vector{T}
end

"""Implémente une pile vide."""
Stack{T}() where T = Stack(Node{T}[])

"""Insère un élément item dans la pile stack."""
push!(stack::Stack, item::Node)= pushfirst!(stack.nodes, item)


"""File de priorité."""
mutable struct PriorityQueue{T} <: AbstractQueue{T}
    nodes::Vector{Node{T}}
    minWeight::Vector{Union{Edge{T}, Nothing}}
end

"""Implémente une file vide."""
PriorityQueue{T}() where T = PriorityQueue(Array{Node{T},1}(), Union{Edge{Node{T}}, Nothing}[])

"""Ajoute `item` à la fin de la file `s`."""
function push!(q::AbstractQueue{T}, item::T) where T
    push!(q.nodes, item)
    q
end


"""Ajoute `item` à la fin de la file `s`."""
function push!(q::PriorityQueue{T}, item::Node{T}) where T
    push!(q.nodes, item)
    push!(q.minWeight, nothing)
    q
end

"""Ajoute `item` et edge à la fin de la file `s`."""
function push!(q::PriorityQueue, item::AbstractNode, edge::AbstractEdge)
    push!(q.nodes, item)
    push!(q.minWeight, edge)
    q
end

#=
"""Retire et renvoie l'objet du début de la file."""
popfirst!(q::AbstractQueue) = popfirst!(q.nodes) && popfirst!(q.minWeight) =#

"""Indique si la file est vide."""
is_empty(q::AbstractQueue) = length(q) == 0

"""Renvoie les noeuds contenus dans la file."""
getNodes(queue::AbstractQueue) = queue.nodes

"""Renvoie les arêtes contenues dans la file queue."""
getEdges(queue::PriorityQueue) = queue.minWeight

"""Renvoie le poids d'un noeud dans la file de priorité queue."""
getWeight(queue::PriorityQueue, node::AbstractNode) = weight(getEdges(queue)[findfirst(x -> isequal(node, x), getNodes(queue))])


"""Donne le nombre d'éléments sur la file."""
length(q::AbstractQueue) = length(q.nodes)

"""Affiche une file."""
function show(q::AbstractQueue)
  for node in q.nodes
    show(node)
  end
end

"""Retire et renvoie l'élément ayant la plus haute priorité."""
function popfirst!(queue::PriorityQueue)
  edges = getEdges(queue)
  # Retourne rien si la liste est vide
  if(length(edges) == 0)
    return nothing
  else
    lowest = edges[1]
    index = 1
    if(length(edges) > 1)
      # On vient chercher l'arête ayant le plus petit poids
      for i in 2:length(edges)
        temp = edges[i]
        if(!isa(temp, Nothing) && weight(temp) <= weight(lowest))
          index = i
        end
      end
    end
    node = queue.nodes[index]
    edge = queue.minWeight[index]
    deleteat!(queue.nodes, index)
    deleteat!(queue.minWeight, index)
    return node, edge
  end
end
