using DEXTra
using Graphs


function straight_line_ref_graph()
    g = Graph(4)
    add_edge!(g, 2,1)
    add_edge!(g, 1,3)
    add_edge!(g, 3,4)
    g
end

@testset "Graph" begin
    ex_graph = smallgraph(:house)
    names = map(string, 1:nv(ex_graph))
    positions = Dict(n=>p for (p, n) in enumerate(names))
    dex_graph = DEXGraph(ex_graph, names, positions)
    @test length(dex_graph.nodes) == nv(ex_graph)

    rem_vertex!(dex_graph, "4") # removing this node should result in a straight line
    ref_g = straight_line_ref_graph()
    @test adjacency_matrix(dex_graph.graph) == adjacency_matrix(ref_g)
   
    # level graph of the straight line graph is the same as the straight line graph
    lvl_graph = get_level_graph(dex_graph, "1") 
    @test adjacency_matrix(lvl_graph.graph) == adjacency_matrix(ref_g)

    # TODO: more thorough tests to come after serialization is implemented
end