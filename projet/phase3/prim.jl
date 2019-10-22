
function constructPrim(graphe::AbstractGraph{T}, node::AbstractNode{T}) where T
    # on crée une file d'attente vide
    file = PriorityQueue()
    arbre = initArbre(graphe)
    # Donne toutes les arêtes à partir d'un noeud
    dict = Dict{Node{T}, Vector{Edge{T}}}()
    for node in graphe.nodes
        dic[node] = []
    end
    for edge in graphe.edges
        dic[getNode1(edge)] = edge
        dic[getNode2(edge)] = edge
    end


end

function majPoidsNoeud(node::AbstractNode{T}, queue::PriorityQueue, dict::Dict{Node{T}, Vector{Edge{T}}}) where T
    for line in queue
        minWeight = minWeight(line)
        minEdge = queue[node,2]
        for edge in dict[node]
            if edge.weight < minWeight
                minWeight=edge.weight
                queue[node, 2] = minEdge
            end
        end
        node.minWeight = minWeight
        queue[node, 2] = minEdge
    end
end

function newEdges(graphe::AbstractGraph{T}, node::AbstractNode{T}, queue::AbstractPriorityQueue) where T

end
