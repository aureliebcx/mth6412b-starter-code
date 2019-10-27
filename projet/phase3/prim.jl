include(joinpath(@__DIR__, "arbrePrim.jl"))

function prim(graphe::AbstractGraph{T}, noeudDepart::AbstractNode{T}) where T

    arbre = initGraphPrim(graphe)
    file = getQueue(arbre)
    # On commence par le premier noeud donné en paramètre : on le supprime de la file d'attente et on met à jour les poids des noeuds restants.
    index = findall(x -> isequal(x, noeudDepart), getNodes(file))
    deleteat!(file.nodes, index)
    majPoidsNoeud!(arbre, noeudDepart)

    # pour chaque noeud de la file de priorité
    while length(file) != 0
        node = popfirst!(file)
        add_edge!(arbre, node)
        majPoidsNoeud!(arbre, node)
    end
    return arbre

end
