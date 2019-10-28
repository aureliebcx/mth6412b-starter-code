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
  poids = 0
  # on crée un tableau avec toutes les arêtes du graphe triées par poids
  aretes = copy(edges(graph))
  sort!(aretes, by = x -> x.weight)

  # pour chaque arête, on regarde si elle coupe un ensemble connexe cad si ses deux noeuds ont une racine différente
  for arete in aretes
    poids = union!(arete, foret, poids)
  end
  println(poids)
  return foret

end


function prim!(graphe::AbstractGraph)

    arbre = initGraphPrim(graphe)
    file = getQueue(arbre)

    # Définit le premier noeud à utiliser
    noeudDepart = popfirst!(file)
    majPoidsNoeud!(arbre, noeudDepart)

    # Pour chaque noeud de la file de priorité
    while !is_empty(file)
        node = popfirst!(file)
        add_edge!(arbre, node)
        majPoidsNoeud!(arbre, node)
    end
    return arbre
end
