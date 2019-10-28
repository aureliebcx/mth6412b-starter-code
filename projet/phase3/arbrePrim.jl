import Base.show
"""Type représentant un arbre de recouvrement minimal donné par l'algo de Prim.
Exemple :
    node1 = Node(1,2, 0, Inf, nothing)
    node2 = Node(2, 1, 0, 2, node3)
    node3 = Node(3, 1, 0, 1, node1)
    node4 = Node(4, 1, 0, Inf, nothing)
    edge1 = Edge(node1, node2, 4)
    edge2 = Edge(node2, node3, 2)
    edge3 = Edge(node1, node3, 1)

    arbre = ([node4], Dict(node1 => [edge1, edge3], node2 => [edge1, edge2], node3 => [edge2, edge3]), 3)
"""

mutable struct Prim{T} <: AbstractGraph{T}
  queue::PriorityQueue{Node{T}}
  nodes::Dict{Node{T}, Vector{Edge{T}}}
  edges:: Vector{Edge{T}}
  weight::Int
end

"""Initialie un arbre vide."""
initPrim(queue::PriorityQueue{Node{T}}, dict::Dict{Node{T}, Vector{Edge{T}}}) where T = Prim(queue, dict, Vector{Edge{T}}(), 0)

"""Initialise un arbre vide avec une file d'attente avec tous les noeuds du graphe et un poids nul."""
function initGraphPrim(graphe::AbstractGraph{T}) where T
    # Donne toutes les arêtes à partir d'un noeud{T
    dic = Dict{Node{T}, Vector{Edge{T}}}()
    for node in graphe.nodes
        dic[node] = []
    end
    for edge in graphe.edges
        push!(dic[getNode1(edge)], edge)
        push!(dic[getNode2(edge)], edge)
    end

    # Crée une file d'attente de noeuds et un graphe de type Prim.
    file = PriorityQueue(collect(keys(dic)))
    prim = initPrim(file, dic)
    return prim
end

"""Renvoie les noeuds d'un arbre de recouvrement."""
getNodes(arbre::Prim) = collect(keys(arbre.nodes))

"""Renvoie les arêtes utilisées pour l'arbre de recouvrement minimal."""
getEdges(arbre::Prim) = arbre.edges

"""Renvoie les arêtes reliant un noeud de l'arbre."""
getEdgesOfNode(arbre::Prim, node::AbstractNode) = arbre.nodes[node]

"""Renvoie le poids de l'arbre."""
getWeight(arbre::Prim) = arbre.weight

"""Renvoie la file d'attente de noeuds."""
getQueue(arbre::Prim) = arbre.queue

"""Met à jour l'arbre : ajoute l'arête minimale d'un noeud à l'arbre de recouvrement minimal."""
function add_edge!(arbre::Prim{T}, noeud::AbstractNode{T}) where T
    minWeight(noeud) == Inf && return error("Noeud non rattaché à l'arbre de recouvrement")
    edges = getEdgesOfNode(arbre, noeud)
    parent = getParent(noeud)
    # Recupère l'arête minimale à ajouter
    index = findfirst(x  -> isequal(parent, getNode1(x)), edges)
    if(index == nothing)
        index = findfirst(x  -> isequal(parent, getNode2(x)), edges)
    end
    push!(arbre.edges, edges[index])
    arbre.weight = arbre.weight + minWeight(noeud)
    return arbre
end

"""Affiche un arbre de recouvrement."""
function show(arbre::Prim)
    println("L'arbre de recouvrement minimal a un poids de ", getWeight(arbre))
end

"""Met à jour le poids associé à chaque noeud lorsqu'on ajoute le noeud en paramètre au graphe en paramètre."""
function majPoidsNoeud!(arbre::Prim{T}, noeud::AbstractNode{T}) where T
    nodes = getNodes(getQueue(arbre))
    edges = getEdgesOfNode(arbre, noeud)
    for node in nodes
        for edge in edges
            if(node == edge.node1 ||  node == edge.node2)
                if(weight(edge)<= minWeight(node))
                    setWeight(node, weight(edge), noeud)
                end
            end
        end
    end
end
