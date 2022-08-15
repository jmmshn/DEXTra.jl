"""
Definitions of core concepts in DEXTra.
"""

"""
    LiquidityPool
A liquidity pool represents a single source of assets.
All trading occurs between liquidity pools.
"""
mutable struct LiquidityPool
    chain::String
    coin::String
    liquidity::Float64  
end

"""
    TradingPair

A trading pair represents a pair of liquidity pools and the exchange function between these pools.

Note: The two pools should always be ordered alphabetically.
"""
mutable struct TradingPair
    name::String
    provider::String
    lp1::LiquidityPool
    lp2::LiquidityPool
    fee::Float64
    exchange_func::Function
    function TradingPair(provider::String, lp1::LiquidityPool, lp2::LiquidityPool, fee::Float64, exchange_func::Function)
        name = "$(provider)|$(lp1.chain):$(lp1.coin)|$(lp2.chain):$(lp2.coin)"
        new(name, provider, lp1, lp2, fee, exchange_func)
    end
end

"""
    get_exchange_func(tp::TradingPair)::Function

Return the univariate exchange function for a given trading pair, using the current liquidity values.
"""
function get_exchange_func(tp::TradingPair)
    return x -> tp.exchange_func(x, tp.fee, tp.lp1.liquidity, tp.lp2.liquidity)
end
