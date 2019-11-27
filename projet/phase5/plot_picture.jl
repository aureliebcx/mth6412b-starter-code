include(joinpath(@__DIR__, "..", "phase4", "RSL.jl"))
include(joinpath(@__DIR__, "..", "phase4", "HK.jl"))
include(joinpath(@__DIR__, "..", "phase1", "read_stsp.jl"))
include(joinpath(@__DIR__, "..", "..",  "shredder", "shredder-julia", "bin", "tools.jl"))

function plot_picture(picture_name::String, use_HK::Bool, nb_it::Int, index_racine::Int)
    # Lecture des données en entrée : création d'un graphe
    image_path = joinpath(@__DIR__, "..", "..", "shredder", "shredder-julia", "tsp", "instances", picture_name)
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
            w[j1, j2] = compareColumn(picture[:, j1], picture[:, j2])
            push!(edges, Edge(nodes[j1 + 1], nodes[j2 + 1], w[j1, j2]))
        end
        # ajout de l'arête de poids 0
        push!(edges, Edge(nodes[1], nodes[j1 + 1], 0))
    end

    graphe = Graph(picture_name, nodes, edges)

    # Construction d'une tournée optimale pour ce graphe
    if use_HK
        tournee = HK(graphe, nb_it, nodes[index_racine])
        weightTournee = getWeight(tournee)
        save_name = "tour_HK_poids-$weightTournee"*"_it-$nb_it"*"_"*picture_name
    else
        tournee = RSL(graphe, nb_it, nodes[index_racine])
        weightTournee = getWeight(tournee)
        save_name = "tour_RSL_poids-$weightTournee"*"_it-$nb_it"*"_"*picture_name
    end

    index_tournee = [data(node) for node in getNodes(getTournee(tournee))]

    # Reconstruction de l'image dans le bon ordre
    tour_path = joinpath(@__DIR__, "..", "..", "shredder", "shredder-julia", "tsp", "tours",save_name)
    write_tour(, index_tournee, weightTournee)

    reconstruct_picture(tour_path, image_path, joinpath(@__DIR__, "..", "..", "shredder", "shredder-julia", "tsp", "reconstructed",save_name))

end
