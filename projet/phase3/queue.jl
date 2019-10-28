import Base.length, Base.push!, Base.popfirst!
import Base.show

"""Type abstrait dont d'autres types de files dériveront."""
abstract type AbstractQueue{T} end


"""Ajoute `item` à la fin de la file `s`."""
function push!(q::AbstractQueue{T}, item::T) where T
    push!(q.nodes, item)
    q
end

"""Retire et renvoie l'objet du début de la file."""
popfirst!(q::AbstractQueue) = popfirst!(q.nodes)

"""Indique si la file est vide."""
is_empty(q::AbstractQueue) = length(q.nodes) == 0

"""Renvoie les noeuds contenus dans la file de priorité."""
getNodes(queue::AbstractQueue) = queue.nodes

"""Donne le nombre d'éléments sur la file."""
length(q::AbstractQueue) = length(q.nodes)

"""Affiche une file."""
show(q::AbstractQueue) = show(q.nodes)

"""File de priorité."""
mutable struct PriorityQueue{T} <: AbstractQueue{T}
    nodes::Vector{T}
end

PriorityQueue{T}() where T = PriorityQueue(T[])

"""Retire et renvoie l'élément ayant la plus haute priorité."""
function popfirst!(queue::PriorityQueue)
  nodes = getNodes(queue)
  index = nothing
  if(length(nodes) == 0)
    return nothing
  else
    highest = nodes[1]
    index = 1
    if(length(nodes) > 1)
      for i in 2:length(nodes)
        temp = nodes[i]
        if(temp.minWeight <= highest.minWeight)
          highest = temp
          index = i
        end
      end
    end
    deleteat!(queue.nodes, index)
    return highest
  end
end
