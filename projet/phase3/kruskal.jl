include(joinpath(@__DIR__, "..", "phase3", "node.jl"))
include(joinpath(@__DIR__, "..", "phase1", "edge.jl"))
include(joinpath(@__DIR__, "..", "phase1", "graph.jl"))
include(joinpath(@__DIR__, "..", "phase2", "arbreRecouvrement.jl"))

"""Retourne un arbre de recouvrement minimal pour un graphe non orienté connexe"""
function algoKruskal(graph::AbstractGraph)
  # on crée un objet de type Arbre pour le graphe
  foret = initArbre(graph)

  # on crée un tableau avec toutes les arêtes du graphe triées par poids
  aretes = copy(edges(graph))
  sort!(aretes, by = x -> x.weight)

  # pour chaque arête, on regarde si elle coupe un ensemble connexe cad si ses deux noeuds ont une racine différente
  for arete in aretes
    union!(arete, foret)
  end
  return foret

end

"""Union de deux noeuds selon le rang de leur racine si elles n'ont pas le même noeud."""
function union!(arete::Edge, foret::Arbre)
  racine1, rang1 = getRacine(foret, getNode1(arete))
  racine2, rang2 = getRacine(foret, getNode2(arete))
  # si oui, on relie les deux ensembles connexes par leurs racines
  if racine1 != racine2
    if rang1 == rang2
      changeParent!(foret, racine1, racine2)
      racine2.rang += 1
      compression!(foret, racine1, racine2)
    elseif rang1 < rang2
      changeParent!(foret, racine1, racine2)
      compression!(foret, racine1, racine2)
    else
      changeParent!(foret, racine2, racine1)
      compression!(foret, racine2, racine1)
    end
    # On ajoute l'arête à l'arbre
    add_edge!(foret, arete)
  end
end

"""
Compresse les chemins entre deux noeuds d'une forêt.
Node 1 est le nouveau noeud enfant.
Node 2 est la nouvelle racine.
"""
function compression!(foret::Arbre, node1::AbstractNode, node2::AbstractNode)
  # Tous les noeuds qui ont pour parents la racine noeud1 vont avoir pour racine le node2
  nodes = findall(x -> x == node1, getParents(foret))
  for node in nodes
    changeParent!(foret, node, node2)
  end

  # Le rang de la racine devient 1 si jamais il est supérieur à 2
  if getRacine(foret, node2)[2] >= 1
    node2.rang = 1
  end
end
