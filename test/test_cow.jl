using DEXTra

@testset "CoW" begin
    o1 = LimitBuyOrder(1, 2, 1000, 2500) # buy 1000 DAI for ETH at a rate of 2500 DAI/ETH or better
    o2 = LimitSellOrder(2, 1, 1000, 2500) # sell 1000 ETH for DAI at a rate of 2500 DAI/ETH or better (BIG ORDER)
    ob = OrderBook([o1, o2], ["ETH", "DAI"])
    # Transact (Buy 1 ETH for 2500 DAI) (sell 1 ETH for 2500 DAI) for a total volume of 5000 USD
    @test total_trade_volume(ob, [1., 2500.], [2500., 1.], [2500., 1.]) == (5000, 5000)
end