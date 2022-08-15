
module ExchangeFunctions

"""
    constant_product(δ::Real, γ::Real, R₁::Real, R₂::Real)::Real

The exchange function for a constant-product market maker (CPMM)
"""
function constant_product(δ::Real, γ::Real, R₁::Real, R₂::Real)::Real
    R₂ * (1 - R₁ / (R₁ + δ * γ))
end

end