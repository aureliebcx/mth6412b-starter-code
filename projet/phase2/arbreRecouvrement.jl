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
mutable struct Kruskal{T} <: AbstractGraph{T}
  arbre::Graph{T}
  parents::Dict{Node{T}, Node{T}}
end


"""Change le parent d'un noeud. """
function changeParent!(tabParents::Kruskal, nodeChild::AbstractNode, nodeFather::AbstractNode)
  tabParents.parents[nodeChild] = nodeFather
  return tabParents
end

"""Renvoie les arêtes de l'arbre."""
getEdges(kruskal::Kruskal) = kruskal.arbre.edges

"""Renvoie les noeuds de l'arbre."""
getNodes(kruskal::Kruskal) = collect(keys(kruskal.parents))

"""Retourne le dictionnaire contenant les noeuds parents de tous les noeuds"""
getParents(graphe::Kruskal) = graphe.parents

"""Renvoie l'arbre de recouvrement."""
getArbre(graphe::Kruskal) = graphe.arbre

"""Retourne le parent du noeud donné s'il existe"""
function getParent(parent::Kruskal{T}, noeud::AbstractNode{T}) where T
  return get(getParents(parent), noeud, ErrorException("le parent n'existe pas"))
end


"""Initialise un objet de type Kruskal pour un graphe"""
function initArbre(graphe::AbstractGraph{T}) where T
  grapheRecouvrement = Graph("Spanning Tree", [node for node in getNodes(graphe)], Edge{T}[])
  init = Dict(node => node for node in getNodes(graphe))
  foret = Kruskal(grapheRecouvrement, init)
  return foret
end

"""Récupère la racine du noeud précisé"""
function getRacine(kruskal::AbstractGraph{T}, noeud::AbstractNode{T}) where T
  enfant = noeud
  parent = getParent(kruskal, noeud)
  while enfant != parent
    enfant = parent
    parent = getParent(kruskal, parent)
  end

  return enfant
end


"""Affiche un arbre de recouvrement minimal."""
function show(kruskal::Kruskal)
  for key in keys(kruskal.parents)
    if(!isa(key, Nothing))
      show(key)
    end
  end

  for edge in kruskal.edges
    show(edge)
  end
end

"""Ajoute l'arête edge à l'arbre de recoubrement kruskal."""
add_edge!(kruskal::Kruskal, edge::AbstractEdge) = add_edge!(kruskal.arbre, edge)
