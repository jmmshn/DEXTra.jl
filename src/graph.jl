# Construction of level graph
# https://github.com/JuliaGraphs/GraphsFlows.jl/blob/37a1c9d5c8e2a3039579b8236bc2f801b67b3b4d/src/dinic.jl#L54-L62

# %%
using Graphs
using DataStructures
import Graphs.rem_vertex!
"""
    DEXGraph

A graph representation of a set of DEXs.  Although the 

**Fields**
* `graph`: The name of the blockchain this liquidity pool is on.
* `nodes`: A list of the unique node labels.
* `positions`: The position of a particular node in `nodes` list.
"""
struct DEXGraph
    graph::Graph # undirected
    nodes::Vector{String}
    positions::Dict{String,Int}
end

function DEXGraph(ex_graph, names)
    positions = Dict(n=>p for (p, n) in enumerate(names))
    return DEXGraph(ex_graph, names, positions)
end

# """
#     DEXGraph(trading_pairs::Vector{TradingPair})

# Constructor for `DEXGraph` object from many `TradingPair`'s.
# """
# function DEXGraph(trading_pairs::Vector{TradingPair})::Tuple{SimpleGraph{Int64}, Vector{String}, Dict{String, Integer}}
#     nodes = Vector{String}()
#     positions = Dict{String, Integer}()
#     for tp in trading_pairs
#         # add_edge!(new_graph, tp.lp1.name, tp.lp1.name)
#         tp.lp1.name ∉ nodes && (push!(nodes,tp.lp1.name); positions[tp.lp1.name] = length(nodes))
#         tp.lp2.name ∉ nodes && (push!(nodes,tp.lp2.name); positions[tp.lp2.name] = length(nodes))
#     end
#     new_graph = Graph(length(nodes))
#     for tp in trading_pairs
#         add_edge!(new_graph, positions[tp.lp1.name], positions[tp.lp2.name])
#     end
#     return DEXGraph(graph=new_graph, nodes=nodes, positions=positions)
# end

"""
    rem_vertex!(dex_graph::DEXGraph, vertex::String)

Remove a vertex by the name of the node and re-index the `nodes` and `positions` fields.
"""
function rem_vertex!(dex_graph::DEXGraph, v::String)
    # swap the vertex to be removed with the last vertex
    rm_vertex, last_vertex = dex_graph.positions[v], length(dex_graph.nodes)
    dex_graph.nodes[rm_vertex], dex_graph.nodes[last_vertex] = dex_graph.nodes[last_vertex], dex_graph.nodes[rm_vertex]
    dex_graph.positions[dex_graph.nodes[rm_vertex]] = rm_vertex
    # remove the last vertex
    if !rem_vertex!(dex_graph.graph, dex_graph.positions[v])
        error("Vertex $v not found.")
    end
    pop!(dex_graph.nodes)
    delete!(dex_graph.positions, v)
end

"""
    get_level_graph(dex_graph::DEXGraph, source::String, sink::String)

Obtain a level graph from a `DEXGraph` object
"""
function get_level_graph(dex_graph::DEXGraph, source::String; trim_interlayer::Bool=true)
    # keep track of the levels and do not allow inter-level connections
    level_graph = Graph(length(dex_graph.nodes))
    qq = [(dex_graph.positions[source], 0)]
    visited = Set([])
    lvl_sets = DefaultDict{Int,Set{Int}}(() -> Set(Int[]))
    while !isempty(qq)
        u, lvl = popfirst!(qq)
        u ∈ visited && continue
        push!(lvl_sets[lvl], u)
        push!(visited, u) 
        for v in outneighbors(dex_graph.graph, u)
            if v ∉ visited
                push!(qq, (v, lvl + 1))
                add_edge!(level_graph, u, v)
            end
        end
    end
    
    if trim_interlayer
        # remove the edges inside each level
        for (_, nodes) in lvl_sets
            for u in nodes
                nn = collect(Set(outneighbors(level_graph, u)) ∩ nodes) # 
                for v in nn # TODO: why does changing this to `level_graph.graph` break things? 
                    rem_edge!(level_graph, u, v)
                end
            end
        end
    end

    # level_graph has the exact indicies of dex_graph.graph
    new_nodes = copy(dex_graph.nodes)
    new_pos = copy(dex_graph.positions)
    out_graph = DEXGraph(level_graph, new_nodes, new_pos)
    # remove the all nodes not in visited
    for (i, name) in enumerate(dex_graph.nodes)
        i ∉ visited && rem_vertex!(out_graph, name)
    end
    return out_graph
end
