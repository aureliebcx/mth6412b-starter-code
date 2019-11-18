import Base.push!
import Base.pushfirst!

"""Type abstrait dont d'autres types de graphes dériveront."""
abstract type AbstractTournee{T} end

"""Type représentant une tournée pour un graphe."""

mutable struct Tournee{T} <: AbstractTournee{T}
  arbre::Prim{T}
  edgesGraphe::Vector{Edge{T}}
  visited::Dict{Node{T}, Bool}
  tournee::Graph{T}
end


"""Renvoie l'arbre de recouvrement."""
getArbre(graphe::AbstractTournee) = graphe.arbre

"""Renvoie les arêtes du graphe."""
getEdges(graphe::AbstractTournee) = graphe.edgesGraphe

"""Renvoie la tournee du graphe."""
getTournee(graphe::AbstractTournee) = graphe.tournee

"""Modifie l'état d'un noeud."""
function setVisited(graphe::Tournee{T}, node::AbstractNode{T}, etat::Bool) where T
  graphe.visited[node] = etat
end

"""Renvoie les noeuds du graphe."""
getNodes(graphe::Tournee) = getNodes(getArbre(graphe))

"""Renvoie l'état d'un noeud."""
getVisited(graphe::Tournee, node::AbstractNode) = graphe.visited[node]

"""Initialise un Tournee à partir d'un graphe."""
function initTournee(graphe::AbstractGraph{T}, racine::AbstractNode{T}) where T
  arbre = prim(graphe, racine)
  edgesGraphe = getEdges(graphe)
  visited =  Dict(node => false for node in getNodes(graphe))
  tournee = Graph(name(graphe), [node for node in getNodes(graphe)], Edge{T}[])
  return Tournee(arbre, edgesGraphe, visited, tournee)
end

"""Renvoie le poids de la tournee associée au graphe."""
getWeight(graphe::AbstractTournee) = getWeight(getTournee(graphe))

"""Ajoute une arête à la tournée de graphe."""
add_edge!(graphe::AbstractTournee{T}, edge::Edge{T}) where T = add_edge!(getTournee(graphe), edge)

"""Ajoute une arête au début de la tournée."""
pushfirst!(graphe::AbstractTournee{T}, edge::Edge{T}) where T = pushfirst!(getEdges(getTournee(graphe)), edge)
