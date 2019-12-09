include(joinpath(@__DIR__, "..", "phase4", "RSL.jl"))
include(joinpath(@__DIR__, "..", "phase4", "HK.jl"))
include(joinpath(@__DIR__, "..", "phase1", "read_stsp.jl"))
include(joinpath(@__DIR__, "..", "..",  "shredder", "shredder-julia", "bin", "tools.jl"))

function plot_picture(picture_name::String, use_HK::Bool, nb_it::Int, index_racine::Int)
    # Lecture des données en entrée : création d'un graphe
    image_path = joinpath(@__DIR__, "..", "..", "shredder", "shredder-julia", "images", "shuffled", picture_name*".png")
    picture = load(image_path)
    nb_row, nb_col = size(picture)

    # création des noeuds pour chaque colonne + noeud 0
    nodes = Vector{Node{Int64}}()
    for k = 0:nb_col
        push!(nodes, Node(k, k))
    end

    # création des arêtes
    edges = Vector{Edge{Int64}}()
    w = zeros(nb_col, nb_col)
    for j1 = 1:nb_col
        for j2 = j1 + 1 : nb_col
            w[j1, j2] = compare_columns(picture[:, j1], picture[:, j2])
            push!(edges, Edge(nodes[j1 + 1], nodes[j2 + 1], floor(Int, w[j1, j2])))
        end
        # ajout de l'arête de poids 0
        push!(edges, Edge(nodes[1], nodes[j1 + 1], 0))
    end

    graphe = Graph(picture_name, nodes, edges)

    # Construction d'une tournée optimale pour ce graphe
    if use_HK
        tournee = HK(graphe, nb_it, index_racine)
        weightTournee = getWeight(tournee)
        save_name = "tour_HK_poids-$weightTournee"*"_it-$nb_it"*"_"*picture_name
    else
        tournee = RSL(graphe, nodes[index_racine], true)
        weightTournee = getWeight(tournee)
        save_name = "tour_RSL_poids-$weightTournee"*"_it-$nb_it"*"_"*picture_name
    end

    # index_tournee = [data(node) for node in getNodes(getTournee(tournee))]
    index_tournee = formation_tournee(tournee)

    # Reconstruction de l'image dans le bon ordre
    tour_path = joinpath("plot", "tours", save_name*".tour")
    reconstructed_path = joinpath("plot", "images", save_name*".png")
    #tour_path = joinpath(@__DIR__, "..", "..", "shredder", "shredder-julia", "tsp", "tours",save_name)
    write_tour(tour_path, index_tournee, convert(Float32, weightTournee))
    reconstruct_picture(tour_path, image_path, reconstructed_path)

end

"""Renvoie un tableau contenant les datas des noeuds dans l'ordre de la tournée."""
function formation_tournee(graphe::AbstractTournee{T}) where T
    tournee = getTournee(graphe)
    edges = copy(getEdges(tournee))
    indexTournee = T[]
    # On va chercher le noeud 0
    nodeFrom = Node(0,0)
    push!(indexTournee, data(nodeFrom))
    nodeTo = nodeFrom

    # tant qu'il reste des arêtes, on cherche le noeud suivant
    while length(edges) != 0
        nodeFrom = nodeTo
        indexTo = findfirst(x -> isequal(getNode1(x), nodeFrom) || isequal(getNode2(x), nodeFrom), edges)
        nodeTo = isequal(nodeFrom, getNode1(edges[indexTo])) ? getNode2(edges[indexTo]) : getNode1(edges[indexTo])
        deleteat!(edges, indexTo)
        push!(indexTournee, data(nodeTo))
    end

    deleteat!(indexTournee, length(indexTournee))
    return indexTournee
end
