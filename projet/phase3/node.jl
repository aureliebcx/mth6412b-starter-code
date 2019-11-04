import Base.show
import Base.Inf
"""Type abstrait dont d'autres types de noeuds dériveront."""
abstract type AbstractNode{T} end

"""Type représentant les noeuds d'un graphe.

Exemple:

        noeud = Node(1, [π, exp(1)], 0)
        noeud = Node(2, "guitar", 0)
        noeud = Node(3, 2, 0)

"""
mutable struct Node{T} <: AbstractNode{T}
  name::Int
  data::T
  rang::Int
  minWeight::Union{Float64, Int}
  parent::Union{Nothing, AbstractNode{}}
end

# on présume que tous les noeuds dérivant d'AbstractNode
# posséderont des champs `name` et `data`.

"""Implémente un noeud avec un rang nul."""
function Node(name::Int, data::T) where T
  Node(name, data, 0, Inf, nothing)
end

"""Renvoie le poids minimal associé au noeud."""
minWeight(node::AbstractNode) = node.minWeight

"""Renvoie le rang du noeud."""
rang(node::AbstractNode) = node.rang

"""Renvoie le nom du noeud."""
name(node::AbstractNode) = node.name

"""Renvoie les données contenues dans le noeud."""
data(node::AbstractNode) = node.data

"""Renvoie le parent du noeud."""
getParent(node::AbstractNode) = node.parent

"""Affiche un noeud."""
function show(node::AbstractNode)
  if(isa(getParent(node), Nothing))
    println("Node ", name(node), ", data: ", data(node), ", minWeight: ", minWeight(node))
  else
    println("Node ", name(node), ", data: ", data(node), ", minWeight: ", minWeight(node), ", parent: ", name(getParent(node)))
  end
end

"""Modifie le poids minimum et le parent associé au noeud."""
function setWeight(node::AbstractNode, weight::Union{Float64, Int}, parent::Union{AbstractNode, Nothing})
  node.minWeight = weight
  node.parent = parent
end

"""Retourne si un noeud est égal à l'autre."""
isequal(node1::AbstractNode, node2::AbstractNode) = node1==node2
