using Statistics
using Printf
using Random
using DataStructures

include(joinpath(@__DIR__, "phase3", "main.jl"))

# List of stsp instances
const STSP_DIR = joinpath(@__DIR__, "..", "instances", "stsp")
const STSP = readdir(STSP_DIR)

const GRAPHS = [construct_graph(joinpath(STSP_DIR, finst), finst[1:end-4]) for finst in STSP]

"""
    benchmark(funcs, graphs, N; [verbose])

Benchmark each function of each graph `N` times.
"""

function benchmark(funcs, graphs, N=16; verbose=false)
    ttot = 0.0
    T = zeros(length(graphs), length(funcs), N)  # Computing times for each graph
    if verbose
        @printf "%12s" ""
        for f in funcs
            @printf "  |  %26s    " "$f"
        end
        @printf "\n"
        println("-"^(14+34*length(funcs)))
    end
    
    for (i, g) in enumerate(graphs)
        verbose && @printf "%12s" name(g)
        for (j, f) in enumerate(funcs)
            times = Float64[]

            # Run once to get weight of MST
            mst = f(g)
            W = sum(weight, edges(mst))
            verbose && @printf "  |%10.2f" W

            for k in 1:N
                t_ = @elapsed f(g)
                ttot += t_
                push!(times, t_)
                T[i, j, k] = t_
            end

            # Compute stats
            μ = 1000 * mean(times)  # mean
            σ = 1000 * std(times)   # standard deviation
            verbose && @printf "  %8.3f (±%8.3f)" μ ((2.0 / sqrt(N)) * σ)
        end
        verbose && @printf "\n"
    end

    # Print totals
    if verbose
        println("-"^(14+34*length(funcs)))
        @printf "%12s" "Totals"
        for (i, f) in enumerate(funcs)
            μ = 1000 * mean(sum(T[:, i, :], dims=1))  # mean
            σ = 1000 * std(sum(T[:, i, :], dims=1))   # standard deviation
            @printf "  |  %10s%8.3f (±%8.3f)" "" μ ((2.0 / sqrt(N)) * σ)
        end
        @printf "\n"

    end
    return nothing
end

# Erdos-Renyi graphs
function erdosRenyi(N::Int, p::Float64; seed=0)

    Random.seed!(0)

    @assert 0.0 < p < 1.0

    # Create nodes
    nodes = [Node(i, nothing) for i in 1:N+1]

    # Create edges
    edges = [[
        Edge{Nothing}(nodes[i], nodes[j], rand())
        for i in 1:N
            for j in i+2:N
                if rand() < p
    ];[
        Edge{Nothing}(nodes[N+1], nodes[i], 1.0 + rand())
        for i in 1:N
    ]]


    g = Graph{Nothing}(
        "ER-$(N)-$(p)",
        nodes,
        edges
    )

    return g
end
const ER = [erdosRenyi(2^k, 0.10) for k in 4:10]

# First round for compilation
for graphs in [GRAPHS, ER]
    benchmark([kruskal, prim!], graphs, 1)
end

N = 2
println("Number of evals: $N")

# STSP graphs
println("STSP graphs")
benchmark([kruskal, prim!], GRAPHS, N, verbose=true)
println()

# Erdos-Renyi graphs
println("ER")
benchmark([kruskal, prim!], ER, N, verbose=true)
println()
