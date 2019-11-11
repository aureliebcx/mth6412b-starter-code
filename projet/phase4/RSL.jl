include(joinpath(@__DIR__, "..", "phase3", "main.jl"))
include(joinpath(@__DIR__, "..", "phase1", "graph.jl"))
include(joinpath(@__DIR__, "..", "phase4", "tournee.jl"))


function RSL(graphe::AbstractGraph{T}, racine::AbstractNode) where T
    # Etape 1 : choix d'une racine
     # pour l'instant l'algo de Prim la choisit automatiquement

    # Etape 2 : Arbre de recouvrement minimal et objet de type RSL
    rsl = initRSL(graphe, racine)

    # Etape 3 : Parcours en pré-ordre
    # parcours!(rsl)
    parcours_pre!(rsl, racine)

    return rsl
end

"""Retourne l'arête correspondante à node1 et node2 dans graphe."""
function find_edge(node1::Node{T}, node2::Node{T}, edges::Vector{Edge{T}}) where T
    index = findfirst(x -> isequal(x.node1, node1) && isequal(x.node2, node2) || isequal(x.node1, node2) && isequal(x.node2, node1), edges)
    return edges[index]
end

"""Parcourt l'arbre de recouvrement minimal dans l'ordre de visite."""
function parcours!(graphe::Rsl)
    # Réinitialisation du graphe
    for node in getNodes(graphe)
        setVisited(graphe, node, false)
    end

    # Point de départ
    noeudDepart = getFirstNode(getArbre(graphe))
    setVisited(graphe, noeudDepart, true)
    edgesArbre = getEdges(getArbre(graphe))
    edgesGraphe = getEdges(graphe)
    # Parcourt les arêtes les unes après les autres dans l'ordre de construction de Prim
    noeudCourant = noeudDepart
    for areteCourante in edgesArbre
        noeudPrecedent = noeudCourant
        # si le noeud 1 de l'arête a été visité, le noeud suivant est le noeud 2 sinon c'est le noeud 1
        getVisited(graphe, getNode1(areteCourante)) == true ?  noeudCourant = getNode2(areteCourante) : noeudCourant = getNode1(areteCourante)
        setVisited(graphe, noeudCourant, true)

        # Cherche l'arête entre le précédent noeud et le noeud Courant et on l'ajoute à la tournee
        edge = find_edge(noeudPrecedent, noeudCourant, edgesGraphe)
        add_edge!(graphe, edge)

    end
    # On ajoute la derniere arête pour revenir au point de départ

    add_edge!(graphe, find_edge(noeudCourant, noeudDepart, edgesGraphe))
    return graphe

end

"""Retourne un ordre de parcours d'un graphe en préordre."""
function parcours_pre!(graphe::Rsl{T}, racine::AbstractNode) where T
    # Réinitialisation du graphe
    for node in getNodes(graphe)
        setVisited(graphe, node, false)
    end

    # Pile de noeud à visiter
    queue = Stack{T}()
    push!(queue, racine)
    push!(queue, racine)
    ordre = Node{T}[]
    edges = getEdges(getArbre(graphe))
    edgesGraphe = getEdges(graphe)
    noeudPrecedent = racine


    while !is_empty(queue)
        noeudCourant = popfirst!(queue)
        push!(ordre, noeudCourant)
        setVisited(graphe, noeudCourant, true)

        # On ajoute l'arête
        noeudCourant != noeudPrecedent && add_edge!(graphe, find_edge(noeudPrecedent, noeudCourant, edgesGraphe))

        # on ajoute les voisins à visiter à la file
        for edge in edges
            node1 = getNode1(edge)
            node2 = getNode2(edge)
            if(node1 == noeudCourant && !getVisited(graphe, node2))
                push!(queue, node2)
            elseif( node2 == noeudCourant && !getVisited(graphe, node1))
                push!(queue, node1)
            end
        end
        noeudPrecedent = noeudCourant
    end

    return ordre

end
