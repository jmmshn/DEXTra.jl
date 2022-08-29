using DEXTra
@testset "Constructors" begin
    lp1 = DEXTra.LiquidityPool("chain1", "coin1", 1000.0)
    lp2 = DEXTra.LiquidityPool("chain2", "coin2", 1000.0)
    exchange_func(x, fee, l1, l2) = x
    tp = DEXTra.TradingPair("provider", lp1, lp2, 0.0, exchange_func)
    @test tp.name == "provider|chain1:coin1|chain2:coin2"
    uni_f = DEXTra.get_univariate(tp)
    @test uni_f(1.0) == 1.0
end