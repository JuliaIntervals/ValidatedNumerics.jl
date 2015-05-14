
include("automatic_differentiation.jl")
include("newton.jl")
include("krawczyk.jl")

typealias Root{T<:Real} @compat Tuple{Interval{T}, Symbol}

function find_roots{T}(f::Function, a::Interval{T}, method::Function=newton)
    method(f, a)
end

function find_roots{T}(f::Function, f_prime::Function, a::Interval{T}, method::Function=newton)
    method(f, f_prime, a)
end

find_roots(f::Function, a::Real, b::Real, method::Function=newton) =
	find_roots(f, @interval(a, b), method)   # type unstable?
