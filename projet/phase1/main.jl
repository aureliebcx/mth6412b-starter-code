import Base.show
include(joinpath(@__DIR__, "..", "phase3", "node.jl"))
include(joinpath(@__DIR__,"edge.jl"))
include(joinpath(@__DIR__,"graph.jl"))
include(joinpath(@__DIR__,"read_stsp.jl"))

function main()
    file_name = "bayg29.tsp"
    graphe = construct_graph(file_name, "test")
    show(graphe)
end


"""fonction qui va créer un graphe à partir d'un fichier"""
function construct_graph(filename::String, graph_name::String)
    #Récupérer les données du fichier
    brut_nodes, brut_edges = read_stsp(joinpath(@__DIR__,"..","..","instances","stsp",filename))
    brut_nodes = sort(brut_nodes) #on trie le tableau des noeuds


    #Pour tous les noeuds du graphe, on crée un objet de type noeud et on l'ajoute au graphe
    nodes = []
    nb_nodes = length(brut_edges)
    #On implémente un tableau de noeuds avec les data vides si il n'y a pas de données à récupérer dans le fichier
    if (length(brut_nodes)==0)
        #les noeuds créés auront pour données un entier valant 0
        nodes = Node{Int64}[]
        for i in 1:nb_nodes
            push!(nodes,Node(i,0))
        end
    # Sinon pour chaque noeud, on crée un objet de type Noeud et on l'ajoute dans le tableau
    else
        T = valtype(brut_nodes)
        nodes = Node{T}[]
        for node_id in keys(brut_nodes)
          node = Node(node_id, brut_nodes[node_id])
          push!(nodes, node)
        end
    end

    #Pour toutes les arêtes, on ajoute l'arête avec son poids au tableau d'arêtes
    edges = Edge{typeof(nodes[1].data)}[] #tableau d'arêtes à implémenter
    name_node1 = 1 #numéro de ligne étudiée (ce qui correspond au premier noeud de l'arête)

    #on vient récupérer chaque ligne k du tableau (le numéro de la ligne correspondant au nom du noeud) pour lire à quel noeud il est relié et avec quel poids
    for k in brut_edges
        for tuple in k
            edge = Edge(nodes[name_node1], nodes[tuple[1]], tuple[2])
            push!(edges, edge)
        end
        name_node1 = name_node1 + 1
    end

    #Création du graphe avec les données récupérées
    graph = Graph(graph_name, nodes, edges)

end

main()
