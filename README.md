# DEXTra.jl

[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://jmmshn.github.io/DEXTra.jl/dev)
[![](https://github.com/jmmshn/DEXTra.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/jmmshn/DEXTra.jl/actions/workflows/ci.yml)

_DEXTra.jl_ is a Julia package for routing and optimizing asset transfers on realistic networks of decentralized exchanges (DEXs).

!!! warning
    This package is still under development and the API is subject to change.

Since each DEX has an independent calculation of slippage and fees, an exact solution for the optimal route is likely to be intractable.
Instead, we use a heuristic approach to find a good solution in a reasonable amount of time.

## Key Features

Our code combines two methods for optimizing asset transfers on DEXs:

1. A coincidence of wants algorithm resolves all the required transfers on a single block.  This is often the most cost-effective solution since it avoids the fees and slippage incurred by routing through one or more DEXs.

2. An optimization algorithm that considers the price impact of different pathways through the network and reports the best combination of paths to minimize the total cost of the transfer.  Note that due to increased slippage observed for large transfers, it is often advantageous to split a large transfer along multiple trading paths.

## Terminology

- **DEX**: A decentralized exchange is a protocol that allows users to trade assets without a central counterparty.  The most popular DEXs are Uniswap, Sushiswap, and Balancer.

- **Liquidity Pool**: A liquidity pool is a collection of some cryptocurrency that is tendered to a DEX to facilitate trading.  
In principle, there is a shared liquidity pool for all assets of one type (e.g. all ETH).  
In practice, some DEXs may have multiple liquidity pools for each asset pair (e.g. ETH/USDC).
We will use both of these definitions in our code depending on what we are trying to do.

- **Coincidence of Wants**: A coincidence of wants is a situation where two users have assets that they want to trade with each other.  In this case, the two users can trade directly with each other without routing through a DEX.

## Development Plans
- [ ] Level graph -> weighted graph -> optimizer pipeline
- [ ] Standardize output API
- [ ] COW algorithm
- [ ] Reading DEX data from Mongodb.
- [ ] Notebook tutorials _a la_ JuliaGraphsTutorials.


## Developers

DEXTra.jl is developed and maintained by Jimmy-Xuan Shen (@jmmshn) 
with discussion and input from:
    - Jesper T. Kristensen
    - Juan Pablo Madrigal Cianci
    - Giorgos Felekis

