# DEXTra.jl

[![](https://img.shields.io/badge/docs-latest-blue.svg)](https://jmmshn.github.io/DEXTra.jl/dev)
[![](https://github.com/jmmshn/DEXTra.jl/actions/workflows/ci.yml/badge.svg)](https://github.com/jmmshn/DEXTra.jl/actions/workflows/ci.yml)

_DEXTra.jl_ is a Julia package for routing and optimizing asset transfers on realistic networks of decentralized exchanges (DEXs).

!!! warning
    This package is still under development and the API is subject to change.

Since each DEX has an independent calculation of slippage and fees, an exact solution for the optimal route is likely to be intractable.
Instead, we use a heuristic approach to find a good solution in a reasonable amount of time.
Our code combines two methods for optimizing asset transfers on DEXs:

1. A coincidence of wants algorithm resolves all the required transfers on a single block.  This is often the most cost-effective solution since it avoids the fees and slippage incurred by routing through one or more DEXs.

2. An optimization algorithm that considers the price impact of different pathways through the network and reports the best combination of paths to minimize the total cost of the transfer.  Note that due to increased slippage observed for large transfers, it is often advantageous to split a large transfer along multiple trading paths.


# Developers

DEXTra.jl is developed by Dr. Jimmy-Xuan Shen (@jmmshn).

