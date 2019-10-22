import Base.show

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
  minWeight::Int
end

# on présume que tous les noeuds dérivant d'AbstractNode
# posséderont des champs `name` et `data`.

"""Implémente un noeud avec un rang nul."""
function Node(name::Int, data::T) where T
  Node(name, data, 0, 0)
end

"""Renvoie le poids minimal associé au noeud."""
minWeight(node::AbstractNode) = node.minWeight

"""Renvoie le rang du noeud."""
rang(node::AbstractNode) = node.rang

"""Renvoie le nom du noeud."""
name(node::AbstractNode) = node.name

"""Renvoie les données contenues dans le noeud."""
data(node::AbstractNode) = node.data

"""Affiche un noeud."""
function show(node::AbstractNode)
  println("Node ", name(node), ", data: ", data(node))
end
