using JuMP, Ipopt, GraphRecipes
import ColorSchemes.leonardo
import DataStructures: DefaultDict
using GraphPlot
import ColorSchemes:diverging_linear_bjr_30_55_c53_n256


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
    buy::Bool
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
    Order(β, σ, x̄, +Inf, π, true)
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
    Order(β, σ, +Inf, ȳ, π, false)
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
    Order(β, σ, x̄, +Inf, +Inf, true)
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
    Order(β, σ, +Inf, ȳ, +Inf, false)
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

**Kwargs**
* `pmap`: A dictionary that maps the index of the asset prices 
    (i.e. if `3 => 1` is in the pmap then prices[1] will be used to represent the price of asset 3).
    This allows you have a small vector representation of the prices.
"""
function total_trade_volume(orderbook::OrderBook, buy_volumes, sell_volumes, prices; pmap = Dict())
    total_buy = 0.
    total_sell = 0.
    for (i, order) in enumerate(orderbook.orders)
        β = order.β in keys(pmap) ? pmap[order.β] : order.β 
        σ = order.σ in keys(pmap) ? pmap[order.σ] : order.σ
        total_buy += buy_volumes[i] * prices[β]
        total_sell += sell_volumes[i] * prices[σ]
    end
    return total_buy + total_sell
end

"""
    get_asset_map(orderbook::OrderBook)

Get a dictionary that maps the index of the assets in the orderbook 
to the index of the assets in the prices vector.
(i.e. if `3 => 1` is in the pmap then prices[1] will be used to 
represent the price of asset 3).
This allows you have a small vector representation of the prices.

**Arguments**
* `orderbook`: The orderbook.
"""
function get_asset_map(orderbook)
    # loop though and only keep the observed currecies, this limits the dimensions of p.
	observed_assets = Set{Int}()
    for order in orderbook.orders
        push!(observed_assets, order.β)
        push!(observed_assets, order.σ)
    end
    observed_assets = sort(collect(observed_assets))
    Dict{Int, Int}( (asset, i) for (i, asset) in enumerate(observed_assets) )
end

"""
    construct_model(opt_func::Function, orderbook::OrderBook)

Construct a JuMP model for the CoW problem.

**Arguments**
* `opt_func`: The function to optimize
* `orderbook`: The orderbook.
"""
function construct_model(opt_func::Function, orderbook::OrderBook)
    model = Model(Ipopt.Optimizer)
    asset_map = get_asset_map(orderbook)
    x = @variable(model, x[i=1:length(orderbook.orders)], lower_bound=0, upper_bound=orderbook.orders[i].x̄)
    y = @variable(model, y[i=1:length(orderbook.orders)], lower_bound=0, upper_bound=orderbook.orders[i].ȳ)
    p = @variable(model, p[i=1:length(asset_map)], lower_bound=0, upper_bound=Inf)
    # objective
    objective = opt_func(orderbook, x, y, p; pmap=asset_map)
    set_objective(model, MOI.MAX_SENSE, objective)
    return model, x, y, p
end

"""
    get_graph(orderbook::OrderBook, prices::Vector; min_val=0, max_val=1000)

Plot the orderbook as a graph.

**Arguments**
* `orderbook`: The orderbook.
* `prices`: A vector of representing all the prices.
"""
function get_graph(orderbook::OrderBook, prices::Vector; min_val=0, max_val=1000, kwargs...)
    g = SimpleDiGraph(length(orderbook.assets))
    cval = DefaultDict(0.)
    for order in orderbook.orders
        uv = order.buy ? (order.σ, order.β) : (order.β, order.σ)
        add_edge!(g, uv...)
        cval[uv...] = min(order.x̄ * prices[order.β], order.ȳ * prices[order.σ])
    end
    vvec = [cval[e.src, e.dst] for e in edges(g)]
    cvec = (vvec .- min_val) ./ (max_val - min_val)
    cc = get(diverging_linear_bjr_30_55_c53_n256, cvec)
    gplot(g; 
        nodefillc="lightblue", 
        edgestrokec = cc, 
        linetype="curve", 
        nodelabel=orderbook.assets,
        edgelabel=string.(round.(vvec; digits=2)),
        kwargs...
    )

end