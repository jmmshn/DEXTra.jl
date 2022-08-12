module DEXTra

include("core.jl")
include("tropical.jl")

"""
    abc(a::Matrix{T}, b::Matrix{T}) where {T <: Number}

Add two matrices.
"""
function abc(a::Matrix{T}, b::Matrix{T}) where {T <: Number}
    return a * b * c
end

end
