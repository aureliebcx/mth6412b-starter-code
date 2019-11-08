import Base.show
import Base.Inf
import Base.isequal
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
end

# on présume que tous les noeuds dérivant d'AbstractNode
# posséderont des champs `name` et `data`.

"""Implémente un noeud avec un rang nul."""
function Node(name::Int, data::T) where T
  Node(name, data, 0)
end


"""Renvoie le rang du noeud."""
rang(node::AbstractNode) = node.rang

"""Renvoie le nom du noeud."""
name(node::AbstractNode) = node.name

"""Renvoie les données contenues dans le noeud."""
data(node::AbstractNode) = node.data

"""Renvoie les données contenues dans un tableau de noeud."""
data(nodes::Vector{Node{T}}) where T = [data(node) for node in nodes]


"""Affiche un noeud."""
function show(node::AbstractNode)
    println("Node ", name(node), ", data: ", data(node))
end

#=
"""Modifie le poids minimum et le parent associé au noeud."""
function setWeight(node::AbstractNode, weight::Union{Float64, Int}, parent::Union{AbstractNode, Nothing})
  node.minWeight = weight
  node.parent = parent
end =#

"""Retourne si un noeud est égal à l'autre."""
isequal(node1::AbstractNode, node2::AbstractNode) = node1.name == node2.name && node1.data == node2.data
