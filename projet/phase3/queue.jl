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
end

"""Implémente une file vide."""
PriorityQueue{T}() where T = PriorityQueue(T[])

"""Ajoute `item` à la fin de la file `s`."""
function push!(q::AbstractQueue{T}, item::T) where T
    push!(q.nodes, item)
    q
end

"""Retire et renvoie l'objet du début de la file."""
popfirst!(q::AbstractQueue) = popfirst!(q.nodes)

"""Indique si la file est vide."""
is_empty(q::AbstractQueue) = length(q.nodes) == 0

"""Renvoie les noeuds contenus dans la file."""
getNodes(queue::AbstractQueue) = queue.nodes

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
  nodes = getNodes(queue)
  # Retourne rien si la liste est vide
  if(length(nodes) == 0)
    return nothing
  else
    lowest = nodes[1]
    index = 1
    if(length(nodes) > 1)
      # On vient chercher le Node ayant le plus petit poids
      for i in 2:length(nodes)
        temp = nodes[i]
        if(temp.minWeight <= lowest.minWeight)
          lowest = temp
          index = i
        end
      end
    end
    deleteat!(queue.nodes, index)
    return lowest
  end
end
