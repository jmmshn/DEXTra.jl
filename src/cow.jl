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


"""
    OrderBook

A stack of orders.

**Fields**
* `orders`: A vector of orders.
* `assets`: A vector of asset names.
"""
struct OrderBook
    orders::Vector{Order}
    assets::Vector{String}
end

"""
    total_trade_volume(orderbook::Orderbook, buy_volumes::Vector{Float64}, sell_volumes::Vector{Float64}, prices::Vector{Float64})

Compute the total trade volume of an orderbook given the buy and sell volumes and prices of each asset.

**Arguments**
* `orderbook`: The orderbook.
* `buy_volumes`: A vector of buy volumes for each asset.
* `sell_volumes`: A vector of sell volumes for each asset.
* `prices`: A vector of representing all the prices.
"""
function total_trade_volume(orderbook::OrderBook, buy_volumes::Vector{T}, sell_volumes::Vector{T}, prices::Vector{T}) where T <: Real
    total_buy = 0.
    total_sell = 0.
    for (i, order) in enumerate(orderbook.orders)
        total_buy += buy_volumes[i] * prices[order.β]
        total_sell += sell_volumes[i] * prices[order.σ]
    end
    return total_buy, total_sell
end

