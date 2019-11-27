import Base.show
import Base.pushfirst!

"""Type représentant un arbre de recouvrement minimal donné par l'algo de Prim.
Exemple :
    node1 = Node(1,2, 0, Inf, nothing)
    node2 = Node(2, 1, 0, 2, node3)
    node3 = Node(3, 1, 0, 1, node1)
    node4 = Node(4, 1, 0, Inf, nothing)
    edge1 = Edge(node1, node2, 4)
    edge2 = Edge(node2, node3, 2)
    edge3 = Edge(node1, node3, 1)

    arbre = (("graphe",[node1, node2, node3], [edge1, edge2, edge3]), ([node1, node2, node3], [nothing, nothing, nothing]) , queue::PriorityQueue, Dict(node1 => [edge1, edge3], node2 => [edge1, edge2], node3 => [edge2, edge3]), node3)
"""
mutable struct Prim{T} <: AbstractGraph{T}
  arbre::Graph{T}
  queue::PriorityQueue{T}
  nodes::Dict{Node{T}, Vector{Edge{T}}}
  firstNode::Union{Nothing, AbstractNode{T}}
end


"""Initialise un arbre vide avec une file d'attente avec tous les noeuds du graphe."""
function initGraphPrim(graphe::AbstractGraph{T}) where T
    arbre = initGraph(graphe)
    # Donne toutes les arêtes à partir d'un noeud
    dic = Dict{Node{T}, Vector{Edge{T}}}()
    for node in graphe.nodes
        dic[node] = []
    end
    for edge in graphe.edges
        push!(dic[getNode1(edge)], edge)
        push!(dic[getNode2(edge)], edge)
    end

    # Crée une file d'attente de noeuds et un graphe de type Prim.
    file = PriorityQueue(Array{Node{T},1}(), Union{Edge{T}, Nothing}[])
    for node in collect(keys(dic))
        push!(file, node)
    end
    prim = Prim(arbre, file, dic, nothing)
    return prim
end

"""Renvoie les noeuds d'un arbre de recouvrement."""
getNodes(prim::Prim) = collect(keys(prim.nodes))

"""Renvoie les arêtes utilisées pour l'arbre de recouvrement minimal."""
getEdges(prim::Prim) = prim.arbre.edges

"""Renvoie les arêtes reliant un noeud de l'arbre."""
getEdgesOfNode(prim::Prim, node::AbstractNode) = prim.nodes[node]

"""Renvoie la file d'attente de noeuds."""
getQueue(prim::Prim) = prim.queue

"""Renvoie l'arbre de recouvrement du graphe prim."""
getArbre(prim::Prim) = prim.arbre


"""Ajoute à l'arbre de type Prim l'arête edge."""
push!(prim::Prim{T}, edge::AbstractEdge{T}) where T = push!(prim.arbre.edges, edge)

"""Ajoute edge en premier dans le tableau d'arêtes de l'arbre de recouvrement de prim."""
pushfirst!(prim::Prim{T}, edge::AbstractEdge{T}) where T = pushfirst!(prim.arbre.edges, edge)

"""Affiche un arbre de recouvrement."""
function show(prim::Prim)
    println("L'arbre de recouvrement minimal a un poids de ", getWeight(prim))
end

"""Met à jour le poids associé à chaque noeud lorsqu'on ajoute le noeud en paramètre au graphe en paramètre."""
function majPoidsNoeud!(prim::Prim{T}, noeud::AbstractNode{T}) where T
    file = getNodes(getQueue(prim))
    edges = getEdgesOfNode(prim, noeud)
    for edge in edges
        noeud == edge.node1 ? noeud2=edge.node2 : noeud2=edge.node1
        if (noeud2 in file && (weight(edge)<= minWeight(prim, noeud2)))
            setWeight(prim, noeud2, edge)
        end

    end

end

"""Met à jour l'arête minimale edge d'un noeud node dans le graphe prim."""
function setWeight(prim::Prim, node::AbstractNode, edge::AbstractEdge)
    index = getIndex(prim, node)
    prim.queue.minWeight[index] = edge
end

"""Renvoie le poids minimum d'un noeud node dans le graphe prim."""
function minWeight(prim::Prim, node::AbstractNode)
    edge = getEdge(prim, node)
    edge === nothing ? minWeight = Inf : minWeight = weight(edge)
    return minWeight
end

"""Renvoie l'arête de poids minimum d'un noeud node dans le graphe prim."""
getEdge(prim::Prim, node::AbstractNode) = prim.queue.minWeight[getIndex(prim, node)]

"""Renvoie l'index de node dans la file de priorité de prim."""
getIndex(prim::Prim, node::AbstractNode) = findfirst(x -> x == node, prim.queue.nodes)

"""Renvoie le noeud de départ."""
getFirstNode(prim::Prim) = prim.firstNode

"""Met à jour le noeud de départ."""
function setFirstNode(prim::Prim, node::AbstractNode)
    prim.firstNode = node
end

"""Ajoute node au dictionnaire de prim."""
function add_node!(prim::Prim{T}, node::AbstractNode{T}, edges::Vector{Edge{T}}) where T
    prim.nodes[node] = edges
end
