module DEXTra
include("core.jl")
include("graph.jl")
include("exchange_functions.jl")
export 
    TradingPair, LiquidityPool, get_univariate, DEXGraph, rem_vertex!, get_level_graph
end