"""Definition of orderbooks as as stacks for CoW

Each order is described by:
    (β, σ, x̄, ȳ, π) 

Where:
    β is the index of the BUY asset
    σ is the index of the SELL asset
    x̄ is the maximum by amount
    ȳ is the maximum sell amount
    π is the maximum exchange rate (i.e. p_β/p_σ ≤ π)

Limit buy order:
    (ETH, DAI, 1000, +∞, 2500) means "Exchange up to 1000 DAI for ETH at a rate of 2500 DAI/ETH or better". 

"""

"""
    Order

A tuple representing an order in the orderbook.

**Fields**
* `β`: The index of the asset being bought.
* `σ`: The index of the asset being sold.
* `x̄`: The maximum buy amount.
* `ȳ`: The maximum sell amount.
* `π`: The maximum exchange rate (i.e. p_β/p_σ ≤ π).
"""
struct Order
    β::Int
    σ::Int
    x̄::Float64
    ȳ::Float64
    π::Float64
end

"""
    LimitBuyOrder

A tuple representing a limit buy order in the orderbook.

**Fields**
* `β`: The index of the asset being bought.
* `σ`: The index of the asset being sold.
* `x̄`: The maximum buy amount.
* `π`: The maximum exchange rate (i.e. p_β/p_σ ≤ π).
"""
function LimitBuyOrder(β, σ, x̄, π)
    Order(β, σ, x̄, +Inf, π)
end

"""
    LimitSellOrder

A tuple representing a limit sell order in the orderbook.

**Fields**
* `β`: The index of the asset being bought.
* `σ`: The index of the asset being sold.
* `ȳ`: The maximum sell amount.
* `π`: The maximum exchange rate (i.e. p_β/p_σ ≤ π).
"""
function LimitSellOrder(β, σ, ȳ, π)
    Order(β, σ, +Inf, ȳ, π)
end

"""
    MarketBuyOrder

A tuple representing a market buy order in the orderbook.

**Fields**
* `β`: The index of the asset being bought.
* `σ`: The index of the asset being sold.
* `x̄`: The maximum buy amount.
"""
function MarketBuyOrder(β, σ, x̄)
    Order(β, σ, x̄, +Inf, +Inf)
end

"""
    MarketSellOrder

A tuple representing a market sell order in the orderbook.

**Fields**
* `β`: The index of the asset being bought.
* `σ`: The index of the asset being sold.
* `ȳ`: The maximum sell amount.
"""
function MarketSellOrder(β, σ, ȳ)
    Order(β, σ, +Inf, ȳ, +Inf)
end

struct Orderbook
    orders::Vector{Order}
end