import Base.push!
"""Type abstrait dont d'autres types de graphes dériveront."""
abstract type AbstractTournee{T} end

"""Type représentant une tournée pour un graphe.
Exemple :
    node1 = Node(1,2, 0, Inf, nothing)
    node2 = Node(2, 1, 0, 2, node3)
    node3 = Node(3, 1, 0, 1, node1)
    node4 = Node(4, 1, 0, Inf, nothing)
    edge1 = Edge(node1, node2, 4)
    edge2 = Edge(node2, node3, 2)
    edge3 = Edge(node1, node3, 1)


"""
mutable struct Rsl{T} <: AbstractTournee{T}
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
function setVisited(graphe::Rsl{T}, node::AbstractNode{T}, etat::Bool) where T
  graphe.visited[node] = etat
end

"""Renvoie les noeuds du graphe."""
getNodes(graphe::Rsl) = getNodes(getArbre(graphe))

"""Renvoie l'état d'un noeud."""
getVisited(graphe::Rsl, node::AbstractNode) = graphe.visited[node]

"""Initialise un rsl à partir d'un graphe."""
function initRSL(graphe::AbstractGraph{T}, racine::AbstractNode{T}) where T
  arbre = prim(graphe, racine)
  edgesGraphe = getEdges(graphe)
  visited =  Dict(node => false for node in getNodes(graphe))
  tournee = Graph(name(graphe), [node for node in getNodes(graphe)], Edge{T}[])
  return Rsl(arbre, edgesGraphe, visited, tournee)
end

"""Renvoie le poids de la tournee associée au graphe."""
getWeight(graphe::AbstractTournee) = getWeight(getTournee(graphe))

"""Ajoute une arête à la tournée de graphe."""
add_edge!(graphe::AbstractTournee{T}, edge::Edge{T}) where T = add_edge!(getTournee(graphe), edge)
