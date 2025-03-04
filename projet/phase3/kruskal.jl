"""Union de deux noeuds selon le rang de leur racine si elles n'ont pas le même noeud."""
function union!(arete::Edge, foret::Kruskal)
  racine1 = getRacine(foret, getNode1(arete))
  rang1 = rang(racine1)
  racine2 = getRacine(foret, getNode2(arete))
  rang2 =  rang(racine2)
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
Node 1 est le nouveau noeud enfant ajouté à l'arbre.
Node 2 est la nouvelle racine.
"""
function compression!(foret::Kruskal, node1::AbstractNode, node2::AbstractNode)
  # Tous les noeuds qui ont pour parents la racine noeud1 vont avoir pour racine le node2
  nodes = findall(x -> x == node1, getParents(foret))
  for node in nodes
    changeParent!(foret, node, node2)
  end

  # Le rang de la racine devient 1 si jamais il est égal à 2
  if rang(getRacine(foret, node2)) >= 1
    node2.rang = 1
  end
end
