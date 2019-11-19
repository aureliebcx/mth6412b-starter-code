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
    W = 0
    sum = 0



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
    racine_prim = isequal(getNode1(edge1), racine) ? getNode2(edge1) : getNode1(edge1)
    index_racine_prim = findfirst(x -> isequal(racine_prim, x), nodes_graphe)
    lastNode = isequal(getNode1(edge2), racine) ? getNode2(edge2) : getNode1(edge2)
    index_lastNode = findfirst(x -> isequal(lastNode, x), nodes_graphe)

    while( k < iteration && d != zeros(n))
        k += 1
        # construction de l'arbre minimum de recouvrement
        mst = prim(Graph("1-arbre", nodes_mst, edges_mst), racine_prim)
    # Calcul des nouveaux poids des arêtes
        # Pour chaque noeud, on calcule le gradient dans le mst
        arbre = getArbre(mst)
        d = [gradient(arbre, node) for node in nodes_graphe]
        # On ajoute les deux arêtes reliant la racine au gradient
        # Première arête
        d[index_racine_prim] += 1
        # deuxième arête qui va relier le dernier noeud à la racine
        d[index_lastNode] += 1
        # Gradient de la racine
        d[index_racine] = 0
        t = 1/sqrt(k)
        pi = pi + d*t
        for i in 1:n
            sum += pi[i] * d[i]
        end
        L = getRealWeight(arbre, edges_true_weight) + 2 * sum
        W = max(L, W)

        for edge in edges_mst
            poids = pi[findfirst(x -> isequal(getNode1(edge), x), nodes_mst)] + pi[findfirst(x -> isequal(getNode2(edge), x), nodes_mst)]
            setWeight(edge, weight(edge) + trunc(Int, poids))
        end

    end
    println("HK réalisé en ", k, " itérations.")
    println( "la borne maximum trouvée est ", W)

    # Construction de la tournée avec l'ordre obtenu par HK
    # Initialisation et construction de l'objet de type Tournee
    visited =  Dict(node => false for node in nodes_graphe)
    initTour = Graph(name(graphe), [node for node in nodes_graphe], Edge{T}[])
    tournee = Tournee(mst, edges_true_weight, visited, initTour)
    parcours_pre!(tournee, racine_prim)

    # Ajout du noeud racine
    push!(tournee, racine)
    # Ajout des deux arêtes reliant le mst à la racine pour former le 1-arbre
    pushfirst!(tournee, edge1)
    # Enlève la dernière arête de la tournee et on la remplace par l'arête revenant à la racine du 1-arbre
    last_edge = getEdges(getTournee(tournee))[length(getEdges(getTournee(tournee)))]
    deleteat!(getEdges(getTournee(tournee)), length(getEdges(getTournee(tournee))))
    last_node = isequal(getNode1(last_edge), racine_prim) ? getNode2(last_edge) : getNode1(last_edge)
    # Remplace par l"arête de retour
    edge_to_add = find_edge(last_node, racine, edges_racine)
    add_edge!(tournee, edge_to_add)
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

"""Calcule le vrai poids de l'arbre de recouvrement minimum."""
function getRealWeight(arbre::Graph{T}, edges::Vector{Edge{T}}) where T
    weight = 0
    for edge in getEdges(arbre)
        # on va chercher le vrai poids de l'arête
        index = findfirst(x -> isequal(x, edge), edges)
        weight = weight + edges[index].weight
    end
    return weight
end
