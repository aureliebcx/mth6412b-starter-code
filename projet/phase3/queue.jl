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
    nodes::Vector{T}
    minWeight::Vector{Union{Int, Float64}}
end

"""Implémente une file vide."""
PriorityQueue{T}() where T = PriorityQueue(T[], Union{Int, Float64}[])

"""Ajoute `item` à la fin de la file `s`."""
function push!(q::AbstractQueue{T}, item::T) where T
    push!(q.nodes, item)
    q
end

"""Ajoute `item` à la fin de la file `s`."""
function push!(q::PriorityQueue{T}, item::T, poids::Union{Float64, Int}) where T
    push!(q.nodes, item)
    push!(q.minWeight, poids)
    q
end

"""Ajoute `item` à la fin de la file `s`."""
function push!(q::PriorityQueue{T}, item::T) where T
    push!(q.nodes, item)
    push!(q.minWeight, Inf)
    q
end

"""Retire et renvoie l'objet du début de la file."""
popfirst!(q::AbstractQueue) = popfirst!(q.nodes) && popfirst!(q.minWeight)

"""Indique si la file est vide."""
is_empty(q::AbstractQueue) = length(q) == 0

"""Renvoie les noeuds contenus dans la file."""
getNodes(queue::AbstractQueue) = queue.nodes

"""Renvoie les poids contenus dans la file queue."""
getWeight(queue::PriorityQueue) = queue.minWeight

"""Renvoie le poids d'un noeud dans la file de priorité queue."""
getWeight(queue::PriorityQueue, node::AbstractNode) = getWeight(queue)[findfirst(isequal(node, x), getNodes(queue))] 

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
  weight = getWeight(queue)
  println(weight)
  # Retourne rien si la liste est vide
  if(length(weight) == 0)
    return nothing
  else
    index = argmin(weight)
    node = queue.nodes[index]
    deleteat!(queue.nodes, index)
    deleteat!(queue.minWeight, index)
    return node
  end
end
