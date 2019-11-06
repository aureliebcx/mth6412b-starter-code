include(joinpath(@__DIR__, "..", "phase3", "main.jl"))
include(joinpath(@__DIR__, "..", "phase1", "graph.jl"))


function RSL(graphe::AbstractGraph{T}, racine::AbstractNode) where T
    # Etape 1 : choix d'une racine
     # pour l'instant l'algo de Prim la choisit automatiquement

    # Etape 2 : Arbre de recouvrement minimal
    arbre = prim!(graphe)
    edges = graphe.edges

    # Etape 3 : Parcours en pré-ordre
    ordre = parcours_pre(arbre, racine)

    # Construction de la tournée

    tournee = Vector{Edge{T}}()
    for k in 1:length(ordre)-1
        # Trouve l'arête entre deux noeuds consécutifs
        edge = find_edge(ordre[k], ordre[k+1], edges)
        tournee = push!(tournee, edge)
    end

    return tournee

end

"""Retourne l'arête correspondante à node1 et node2 dans graphe."""
function find_edge(node1::Node{T}, node2::Node{T}, edges::Vector{Edge{T}}) where T
    index = findfirst(x -> isequal(x.node1, node1) && isequal(x.node2, node2) || isequal(x.node1, node2) && isequal(x.node2, node1), edges)
    return edges[index]
end

"""Retourne un ordre de parcours d'un graphe en préordre."""
function parcours_pre(arbre::Union{Prim{T}, Arbre{T}}, racine::Node{T}) where T
    # on initialise le parcours du graphe
    for node in getNodes(arbre)
        setVisited(node, false)
    end

    # Pile de noeud à visiter
    queue = Stack{T}()
    push!(queue, racine)
    push!(queue, racine)
    edges = getEdges(arbre)
    ordre = Vector{Node{T}}()

    while !is_empty(queue)
        node = popfirst!(queue)
        node.visited = true
        # On ajoute le noeud au tableau d'ordre de visite

        push!(ordre, node)
        # on ajoute les voisins à visiter à la file
        for edge in edges

            node1 = getNode1(edge)
            node2 = getNode2(edge)
            if(node1 == node && !getVisited(node2))
                push!(queue, node2)
            elseif( node2 == node && !getVisited(node1))
                push!(queue, node1)
            end
        end
    end


    return ordre

end
