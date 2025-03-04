include(joinpath(@__DIR__, "..", "phase3", "main.jl"))
include(joinpath(@__DIR__, "..", "phase1", "graph.jl"))
include(joinpath(@__DIR__, "..", "phase4", "tournee.jl"))

"""Crée une tournée à partir d'arbre représentant un arbre de recouvrement minimal."""
function RSL(arbre::AbstractGraph{T}, racine::AbstractNode, use_prim::Bool) where T
    # Etape 1 : création d'un objet de type Tournee avec prim ou kruskal
    rsl = initTournee(arbre, racine, use_prim)

    # Etape 2 : Construction de la tournée
    parcours_pre!(rsl, racine)

    return rsl
end


"""Retourne l'arête correspondante à node1 et node2 dans graphe."""
function find_edge(node1::Node{T}, node2::Node{T}, edges::Vector{Edge{T}}) where T
    index = findfirst(x -> isequal(x.node1, node1) && isequal(x.node2, node2) || isequal(x.node1, node2) && isequal(x.node2, node1), edges)
    return edges[index]
end


"""Retourne un ordre de parcours d'un graphe en préordre."""
function parcours_pre!(graphe::Tournee{T}, racine::AbstractNode{T}) where T

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
        !isequal(noeudCourant, noeudPrecedent) && add_edge!(graphe, find_edge(noeudPrecedent, noeudCourant, edgesGraphe))


        # on ajoute les voisins à visiter à la file
        for edge in edges
            node1 = getNode1(edge)
            node2 = getNode2(edge)
            if(isequal(node1, noeudCourant) && !getVisited(graphe, node2))
                push!(queue, node2)
            elseif( isequal(node2, noeudCourant) && !getVisited(graphe, node1))
                push!(queue, node1)
            end
        end
        noeudPrecedent = noeudCourant
    end

    return graphe

end

#= Mauvaise fonction

"""Parcourt l'arbre de recouvrement minimal dans l'ordre de visite (ordre des arêtes ajoutées dans l'attribut edges de arbre de graphe) pour former un tour."""
function parcours!(graphe::Tournee, racine::Node)
    # Pour l'instant, l'argument racine n'est pas utilisé
    # Point de départ
    noeudDepart = getFirstNode(getArbre(graphe))
    setVisited(graphe, noeudDepart, true)

    # Paramètres utiles
    edgesArbre = getEdges(getArbre(graphe))
    edgesGraphe = getEdges(graphe)

    # Parcourt les arêtes de l'arbre les unes après les autres dans l'ordre de construction de Prim
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
=#
