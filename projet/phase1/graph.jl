import Base.show

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

"""Type représentant les parents de chaque noeud d'un graphe pour un arbre de recouvrement.
Exemple :
    node1 = Node(1,2)
    node2 = Node(2,1)
    node3 = Node(3,1)
    edge1 = Edge(node1, node2, 4)
    edge2 = Edge(node2, node3, 2)
    edge3 = Edge(node1, node3, 1)

    arbre = ("Arbre de recouvrement", Dict(node1 => node3, node1 => node2, node2 => node3), [edge1, edge2, edge3]
"""
mutable struct Arbre{T} <: AbstractGraph{T}
  name::String
  link::Dict{Node{T}, Node{T}}
  edges::Vector{Edge{T}}
end

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
nodes(graph::Graph) = graph.nodes

"""Renvoie le nombre de noeuds du graphe."""
nb_nodes(graph::Graph) = length(graph.nodes)

"""Renvoie la liste des arêtes du graphe."""
edges(graph::AbstractGraph) = graph.edges

"""Renvoie le nombre d'arêtes du graphe."""
nb_edges(graph::AbstractGraph) = length(graph.edges)

"""Affiche un graphe"""
function show(graph::Graph)
  println("Graph ", name(graph), " has ", nb_nodes(graph), " nodes.")
  println(" and ", nb_edges(graph), "edges.")
end
