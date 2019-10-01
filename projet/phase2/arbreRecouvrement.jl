import Base.show

"""Type abstrait dont d'autres types de noeuds dériveront."""
abstract type AbstractArbre{T} end

"""Type représentant les parents de chaque noeud d'un graphe pour un arbre de recouvrement.
"""
mutable struct Arbre{T} <: AbstractArbre{T}
  name::String
  link::Dict{Node{T}, Node{T}}
  edges::Vector{Edge{T}}
end

"""Fonction changeant le parent d'un noeud"""
function changeParent!(tabParents::AbstractArbre, nodeChild::AbstractNode, nodeFather::AbstractNode)
  tabParents.link[nodeChild] = nodeFather
  return tabParents
end

"""Fonction retournant le dictionnaire contenant les noeuds parents de tous les noeuds"""
getParents(graphe::Arbre) = graphe.link

"""Fonction retournant le nom de l'objet arbre"""
getName(parent::AbstractArbre) = parent.name

"""Fonction retournant le parent du noeud donné s'il existe"""
function getParent(parent::AbstractArbre{T}, noeud::AbstractNode{T}) where T
  return get(getParents(parent), noeud, 0)
end


"""Fonction initialisant un objet de type Arbre pour un graphe"""
function initArbre(graphe::AbstractGraph{T}) where T
  init = Dict{Node{typeNode(graphe)}, Node{typeNode(graphe)}}()
  edges = graphe.edges
  foret = Arbre(name(graphe), init, edges)
  for noeud in nodes(graphe)
    foret.link[noeud] = noeud
  end
  return foret
end

"""Fonction récupérant la racine du noeud précisé"""
function getRacine(arbre::AbstractArbre{T}, noeud::AbstractNode{T}) where T
  enfant = noeud
  parent = getParent(arbre, noeud)

  while enfant != parent
    enfant = parent
    parent = getParent(arbre, parent)
  end
  return enfant
end
