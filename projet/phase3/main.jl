include(joinpath(@__DIR__, "..", "phase3", "node.jl"))
include(joinpath(@__DIR__, "..", "phase1", "edge.jl"))
include(joinpath(@__DIR__, "..", "phase1", "graph.jl"))
include(joinpath(@__DIR__, "..", "phase1", "read_stsp.jl"))
include(joinpath(@__DIR__, "..", "phase1", "graphConstruction.jl"))
include(joinpath(@__DIR__, "..", "phase2", "arbreRecouvrement.jl"))
include(joinpath(@__DIR__, "queue.jl"))
include(joinpath(@__DIR__, "arbrePrim.jl"))
include(joinpath(@__DIR__, "kruskal.jl"))

""""Retourne un arbre de recouvrement minimal pour un graphe non orienté connexe"""
function kruskal(graph::AbstractGraph)
  # on crée un objet de type Arbre pour le graphe
  foret = initArbre(graph)
  # on crée un tableau avec toutes les arêtes du graphe triées par poids
  aretes = copy(getEdges(graph))
  sort!(aretes, by = x -> x.weight)

  # pour chaque arête, on regarde si elle coupe un ensemble connexe cad si ses deux noeuds ont une racine différente
  for arete in aretes
    union!(arete, foret)
  end

  return foret

end


function prim(graphe::AbstractGraph, noeudDepart::AbstractNode)

    prim = initGraphPrim(graphe)
    file = getQueue(prim)

    # Définit le premier noeud à utiliser
    # noeudDepart, edge = popfirst!(file)
    index = getIndex(prim, noeudDepart)
    deleteat!(file.nodes, index)
    deleteat!(file.minWeight, index)
    setFirstNode(prim, noeudDepart)
    majPoidsNoeud!(prim, noeudDepart)

    # Pour chaque noeud de la file de priorité
    while !is_empty(file)
        node, edge = popfirst!(file)
        push!(prim, edge)
        majPoidsNoeud!(prim, node)
    end
    return prim
end


"""Renvoie le poids du graphe."""
function getWeight(graphe::Union{Prim, Kruskal})
    w = 0
    for edge in getEdges(getArbre(graphe))
        w += edge.weight
    end
    return w
end
