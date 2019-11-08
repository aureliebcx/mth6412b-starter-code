import Base.show
import Base.isequal

"""Type abstrait dont d'autres types d'arêtes dériveront."""
abstract type AbstractEdge{T} end

"""Type représentant les arêtes d'un graphe.

Exemple:

        arete = (Node1, Node2, 4)
        arete = (Node2, Node3, 1)

"""

mutable struct Edge{T} <: AbstractEdge{T}
  node1::AbstractNode{T}
  node2::AbstractNode{T}
  weight::Int
end

# on présume que tous les noeuds dérivant d'AbstractEdge
# posséderont des champs 'node1', 'node2' et 'data'.

"""Renvoie les deux noeuds de l'arête."""
getNode1(edge::AbstractEdge) = edge.node1
getNode2(edge::AbstractEdge) = edge.node2

"""Renvoie les données contenues dans l'arête."""
weight(edge::Union{Nothing, AbstractEdge}) = isa(edge, Nothing) ? Inf : edge.weight

"""Affiche une arête."""
function show(edge::AbstractEdge)
  println("Edge from ", name(getNode1(edge)), " to ", name(getNode2(edge)), ", weighting ", weight(edge), ".")
end

function isequal(edge1::AbstractEdge, edge2::AbstractEdge)
  isequal(getNode1(edge1),getNode1(edge2)) && isequal(getNode2(edge1),getNode2(edge2)) && return true
  return false
end
