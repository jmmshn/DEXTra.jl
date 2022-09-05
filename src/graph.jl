# Construction of level graph
# https://github.com/JuliaGraphs/GraphsFlows.jl/blob/37a1c9d5c8e2a3039579b8236bc2f801b67b3b4d/src/dinic.jl#L54-L62

# %%
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

# """
#     rem_vertex!(dex_graph::DEXGraph, vertex::String)

# Remove a vertex by the name of the node and re-index the `nodes` and `positions` fields.
# """
# function rem_vertex!(g::DEXGraph, v::String)
#     # update positions
#     for (k, p) in g.positions
#         if p > g.positions[v]
#             g.positions[k] = p - 1
#         end
#     end
#     deleteat!(g.nodes, g.positions[v])
#     delete!(g.positions, v)
#     rem_vertex!(g.graph, g.positions[v])
# end

# """
#     get_level_graph(dex_graph::DEXGraph, source::String, sink::String)

# Obtain a level graph from a `DEXGraph` object

# **Fields**
# * `graph`: The name of the blockchain this liquidity pool is on.
# * `nodes`: A list of the unique node labels.
# * `positions`: The position of a particular node in `nodes` list.
# """
# function get_level_graph(dex_graph::DEXGraph, source::String, sink::String)
#     # get the level graph
#     level_graph = Graph(length(dex_graph.nodes))
#     qq = [dex_graph.positions[source]]
#     visited = Set([])
#     while !isempty(qq)
#         u = popfirst!(qq)
#         for v in outneighbors(dex_graph.graph, u)
#             if v ∉ visited
#                 push!(qq, v)
#                 add_edge!(level_graph, u, v)
#             end
#         end
#         push!(visited, u)
#     end
#     # remove the all nodes not in visited
#     for v in dex_graph.nodes
#         v ∉ visited && rem_vertex!(level_graph, v)
#     end
#     return level_graph
# end
