using DEXTra

@testset "Graph" begin
    ex_graph = smallgraph(:karate)
    names = map
    dex_graph = DEXGraph(ex_graph, names, positions)
    @test length(dex_graph.nodes) == nv(ex_graph)
end