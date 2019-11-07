import Base.show
include(joinpath(@__DIR__,"..", "phase3","node.jl"))

"""Type abstrait dont d'autres types de graphes dériveront."""
abstract type AbstractGraph{T} end

"""Type representant un graphe comme un ensemble de noeuds.

Exemple :

    node1 = Node("Joe", 3.14)
    node2 = Node("Steve", exp(1))
    node3 = Node("Jill", 4.12)
    edge1 = Edge("Frère", node1, node2, 4)
    edge2 = Edge("Ami", node2, node3, 7)
    G = Graph("Ick", [node1, node2, node3], [edge1, edge2])

Attention, tous les noeuds doivent avoir des données de même type.
"""
mutable struct Graph{T} <: AbstractGraph{T}
  name::String
  nodes::Vector{Node{T}}
  edges::Vector{Edge{T}}
end

"""Initialise un objet de type Graph sans arêtes à partir de graphe."""
initGraph(graphe::Graph{T}) where T = Graph(name(graphe), getNodes(graphe), Vector{Edge{T}}())

"""Ajoute un noeud au graphe."""
function add_node!(graph::Graph{T}, node::Node{T}) where T
  push!(graph.nodes, node)
  graph
end

"""Ajoute une arête au graphe."""
function add_edge!(graph::AbstractGraph{T}, edge::Edge{T}) where T
  push!(graph.edges, edge)
  graph
end

"""Renvoie le type des noeuds dans le graphe"""
typeNode(graph::Graph{T}) where T = T

# on présume que tous les graphes dérivant d'AbstractGraph
# posséderont des champs `name` et `nodes`.

"""Renvoie le nom du graphe."""
name(graph::AbstractGraph) = graph.name

"""Renvoie la liste des noeuds du graphe."""
getNodes(graph::Graph) = graph.nodes

"""Renvoie le nombre de noeuds du graphe."""
nb_nodes(graph::Graph) = length(graph.nodes)

"""Renvoie la liste des arêtes du graphe."""
getEdges(graph::AbstractGraph) = graph.edges

"""Renvoie le nombre d'arêtes du graphe."""
nb_edges(graph::AbstractGraph) = length(graph.edges)

"""Affiche un graphe"""
function show(graph::Graph)
  println("Graph ", name(graph), " has ", nb_nodes(graph), " nodes.")
  println(" and ", nb_edges(graph), "edges.")
end
