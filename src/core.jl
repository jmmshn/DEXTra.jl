"""
Definitions of core concepts in DEXTra.
"""

"""
    LiquidityPool

A liquidity pool represents a single source of assets and can be thought of
as the nodes in a graph. All trading must occur between liquidity pools.

**Fields**

* `chain`: The name of the blockchain this liquidity pool is on.
* `coin`: The name of the coin
* `liquidity`: The amount of liquidity in the pool denominated it's own coin.
* `name`: Allows addtional identification options if there are multiple
  liquidity pools for the same coin on the same chain.

"""
mutable struct LiquidityPool
    chain::String
    coin::String
    liquidity::Float64
    name::String
    function LiquidityPool(
        chain::String,
        coin::String,
        liquidity::Float64;
        name::String = "",
    )
        name = name == "" ? "$(chain):$(coin)" : name
        return new(chain, coin, liquidity, name)
    end
end

"""
    TradingPair

A trading pair represents a pair of liquidity pools and the exchange function between these pools.

!!! note
    The two pools should always be ordered alphabetically.

**Fields**

* `provider`: The name of the service provider ex. Uniswap, Sushiswap, etc.
* `pool1`: The first liquidity pool in the trading pair.
* `pool2`: The second liquidity pool in the trading pair.
* `fee`: The fee charged for exchanges on this trading pair.
* `exchange_func`: The exchange function between the two pools.

"""
mutable struct TradingPair
    name::String
    provider::String
    lp1::LiquidityPool
    lp2::LiquidityPool
    fee::Float64
    exchange_func::Function
    function TradingPair(
        provider::String,
        lp1::LiquidityPool,
        lp2::LiquidityPool,
        fee::Float64,
        exchange_func::Function,
    )
        name = "$(provider)|$(lp1.name)|$(lp2.name)"
        new(name, provider, lp1, lp2, fee, exchange_func)
    end
end

"""
    get_univariate(tp::TradingPair; direction::Symbol)::Function

Return the univariate exchange function for a given trading pair, using the current liquidity values.
"""
function get_univariate(tp::TradingPair; direction::Symbol = :forward)::Function
    if direction == :forward
        return δ -> tp.exchange_func(δ, tp.fee, tp.lp1.liquidity, tp.lp2.liquidity)
    else
        return δ -> tp.exchange_func(δ, tp.fee, tp.lp2.liquidity, tp.lp1.liquidity)
    end
end

"""
    get_univariate(tps::Array{TradingPair}; directions::Array{Symbol})::Function

Compose multiple univariate exchange functions into a single function.
"""
function get_univariate(tps::Array{TradingPair}; directions::Array{Symbol})::Function
    if tps.length != directions.length
        error("Number of trading pairs and directions must match.")
    end
    funcs = map(tp_d -> get_univariate(tp_d...), zip(tps, directions))
    δ -> foldl(|>, funcs, init = δ)
end
