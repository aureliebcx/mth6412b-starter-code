"""Implémente l'algorithme de Held & Karp sur un graphe."""
function HK(graphe_input::AbstractGraph{T}, iteration::Int, index_racine::Int) where T
    # Initialisation des variables nécessaires
    # graphe initial dont le poids des arêtes va être modifié
    graphe = deepcopy(graphe_input)
    nodes_graphe = getNodes(graphe)
    edges_graphe = getEdges(graphe)
    edges_true_weight = deepcopy(edges_graphe)

    mst = initGraphPrim(graphe)
    # données pour les itération de HK
    n = length(nodes_graphe)
    pi = zeros(n)
    d = ones(n)
    t = 1
    k = 0

    # Construction du tableau de noeud et d'arêtes pour la construction de l'arbre de recouvrement minimal
    nodes_mst = copy(nodes_graphe)
    racine = nodes_mst[index_racine]
    deleteat!(nodes_mst, index_racine)

    edges_mst = copy(edges_graphe)
    index_edges = findall(x -> isequal(x.node1, racine) || isequal(x.node2, racine), edges_mst)
    edges_racine = edges_mst[index_edges]
    deleteat!(edges_mst, index_edges)

    edge1, edge2 = edges_min!(edges_racine)
    # racine pour construire Prim devient l'extremité de la première arête
    racine_prim = getNode1(edge1) == racine ? getNode2(edge1) : getNode1(edge1)

    while( k < iteration && d != zeros(n))
        k += 1
        # construction de l'arbre minimum de recouvrement
        mst = prim(Graph("1-arbre", nodes_mst, edges_mst), racine_prim)

    # Calcul des nouveaux poids des arêtes
        # Pour chaque noeud, on calcule le gradient dans le mst
        arbre = getArbre(mst)
        d = [gradient(arbre, node) for node in nodes_graphe]
        # On ajoute les deux arêtes reliant la racine au gradient
        index_racine_prim = findfirst(x -> isequal(racine_prim, x), nodes_graphe)
        d[index_racine_prim] += 1
        # noeud au bout de la deuxième arête de poids minimum
        lastNode = getNode1(edge2) == racine ? getNode2(edge2) : getNode1(edge2)
        index_lastNode = findfirst(x -> isequal(lastNode, x), nodes_graphe)
        d[index_lastNode] += 1
        t = 1/k
        pi = pi + d*t

        for edge in edges_mst
            poids = pi[findfirst(x -> isequal(getNode1(edge), x), nodes_mst)] + pi[findfirst(x -> isequal(getNode2(edge), x), nodes_mst)]
            setWeight(edge, weight(edge) + trunc(Int, poids))
        end

    end
    println("HK réalisé en ", k, " itérations.")

    # Construction de la tournée avec l'ordre obtenu par HK
    # Initialisation et construction de l'objet de type Tournee
    visited =  Dict(node => false for node in nodes_graphe)
    initTour = Graph(name(graphe), [node for node in nodes_graphe], Edge{T}[])
    tournee = Tournee(mst, edges_true_weight, visited, initTour)
    parcours!(tournee, racine)

    # Ajout des deux arêtes reliant le mst à la racine pour former le 1-arbre
    pushfirst!(tournee, edge1)
    # On retire la dernière arête de la tournée
    deleteat!(tournee.tournee.edges, length(tournee.tournee.edges))
    # Remplace par l"arête de retour
    # last_edge = find_edge(lastNode, racine, edges_racine)
    add_edge!(tournee, edge2)
    return tournee
end

"""Recherche les deux arêtes de poids minimum dans edges."""
function edges_min!(edges::Vector{Edge{T}}) where T
    edge1, index1 = findmin(edges)
    deleteat!(edges, index1)
    if isequal(getNode1(edge1), getNode2(edge1))
        edge1, index1 = findmin(edges)
        deleteat!(edges, index1)
    end
    edge2, index2 = findmin(edges)
    return edge1, edge2
end

"""Calcule le  gradient de node dans graphe."""
function gradient(graphe::Graph{T}, node::AbstractNode{T}) where T
    gradient = length(findall(x -> isequal(x.node1, node) || isequal(x.node2, node), getEdges(graphe))) - 2
end

"""Retourne le dernier noeud visité d'un arbre de recouvrement minimal."""
function lastNode(mst::Prim)
    edges = getEdges(getArbre(mst))
    lastEdge = edges[lenght(edges)]
    lastNode = getNode1(lastEdge) == getFirstNode(prim) ? getNode2(lastEdge) : getNode1(lastEdge)
end
