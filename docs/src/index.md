# DEXTra.jl

_DEXTra.jl_ is a Julia package for routing and optimizing asset transfers on realistic networks of decentralized exchanges (DEXs).

!!! warning
    This package is still under development and the API is subject to change.

Since each DEX has an independent calculation of slippage and fees, a exact solution for the optimal route is likely to be intractable.
Instead, we use a heuristic approach to find a good solution in a reasonable amount of time.
Our code combines two methodes for optimizig asset transfers on DEXs:

1. A coincidence of wants algorithm resolve all the required transfers on a single block.  This is often the most cost effective solution since it avoids the fees and slippage incurred by routing through one or more DEXs.

2. An optimization algorithm that consider the price impact of different pathways through the network and reports the best combination of paths to minimize the total cost of the transfer.  Note that due to increased slippage observed for large transfers, it is often advantageous to split a large transfer along multiple trading paths.


# Developers

DEXTra.jl developed by Dr. Jimmy-Xuan Shen (@jmmshn).