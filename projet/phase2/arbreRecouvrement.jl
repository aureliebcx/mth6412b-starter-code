import Base.show
import Base.push!
include(joinpath(@__DIR__,"..", "phase1","graph.jl"))


"""Type représentant les parents de chaque noeud d'un graphe pour un arbre de recouvrement.
Exemple :
    node1 = Node(1,2)
    node2 = Node(2,1)
    node3 = Node(3,1)
    edge1 = Edge(node1, node2, 4)
    edge2 = Edge(node2, node3, 2)
    edge3 = Edge(node1, node3, 1)

    arbre = ("Arbre de recouvrement", Dict(node1 => node3, node1 => node2, node2 => node3), [edge2, edge3])
"""
mutable struct Arbre{T} <: AbstractGraph{T}
  name::String
  link::Dict{Node{T}, Node{T}}
  edges::Vector{Edge{T}}
end

"""Change le parent d'un noeud. """
function changeParent!(tabParents::Arbre, nodeChild::AbstractNode, nodeFather::AbstractNode)
  tabParents.link[nodeChild] = nodeFather
  return tabParents
end

"""Renvoie les arêtes de l'arbre."""
getEdges(arbre::Arbre) = arbre.edges

"""Retourne le dictionnaire contenant les noeuds parents de tous les noeuds"""
getParents(graphe::Arbre) = graphe.link


"""Retourne le parent du noeud donné s'il existe"""
function getParent(parent::Arbre{T}, noeud::AbstractNode{T}) where T
  return get(getParents(parent), noeud, ErrorException("le parent n'existe pas"))
end


"""Initialise un objet de type Arbre pour un graphe"""
function initArbre(graphe::AbstractGraph{T}) where T
  init = Dict(node => node for node in nodes(graphe))
  edges = Edge{typeNode(graphe)}[]
  foret = Arbre(name(graphe), init, edges)
  return foret
end

"""Récupère la racine du noeud précisé"""
function getRacine(arbre::AbstractGraph{T}, noeud::AbstractNode{T}) where T
  enfant = noeud
  parent = getParent(arbre, noeud)
  while enfant != parent
    enfant = parent
    parent = getParent(arbre, parent)
  end

  return enfant, enfant.rang
end


"""Affiche un arbre de recouvrement minimal."""
function show(arbre::Arbre)
  for key in keys(arbre.link)
    if(key != nothing)
      show(key)
    end
  end

  for edge in arbre.edges
    show(edge)
  end

end
