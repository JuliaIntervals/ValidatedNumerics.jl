# This file is part of the ValidatedNumerics.jl package; MIT licensed

# The order in which files are included is important,
# since certain things need to be defined before others use them

## BareInterval type

abstract AbstractBareInterval <: Real

immutable BareInterval{T<:Real} <: AbstractBareInterval
    lo :: T
    hi :: T

    function BareInterval(a::Real, b::Real)

        if a > b
            (isinf(a) && isinf(b)) && return new(a, b)  # empty interval = [∞,-∞]

            throw(ArgumentError("Must have a ≤ b to construct BareInterval(a, b)."))
        end

        new(a, b)
    end
end


## Outer constructors

BareInterval{T<:Real}(a::T, b::T) = BareInterval{T}(a, b)
BareInterval{T<:Real}(a::T) = BareInterval(a, a)
BareInterval(a::Tuple) = BareInterval(a...)
BareInterval{T<:Real, S<:Real}(a::T, b::S) = BareInterval(promote(a,b)...)

## Concrete constructors for BareInterval, to effectively deal only with Float64,
# BigFloat or Rational{Integer} intervals.
BareInterval{T<:Integer}(a::T, b::T) = BareInterval(float(a), float(b))
BareInterval{T<:Irrational}(a::T, b::T) = BareInterval(float(a), float(b))

eltype{T<:Real}(x::BareInterval{T}) = T


## Include files
include("special.jl")
include("macros.jl")
include("conversion.jl")
include("precision.jl")
include("arithmetic.jl")
include("functions.jl")
include("trigonometric.jl")
include("hyperbolic.jl")


# Syntax for intervals

a..b = @interval(a, b)

macro I_str(ex)  # I"[3,4]"
    @interval(ex)
end

a ± b = (a-b)..(a+b)
