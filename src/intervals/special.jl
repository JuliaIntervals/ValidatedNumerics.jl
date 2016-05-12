# This file is part of the ValidatedNumerics.jl package; MIT licensed

## Definitions of special intervals and associated functions

## Empty interval:
doc"""`emptyinterval`s are represented as the interval [∞, -∞]; note
that this interval is an exception to the fact that the lower bound is
larger than the upper one."""
emptyinterval{T<:Real}(::Type{T}) = BareInterval{T}(Inf, -Inf)
emptyinterval{T<:Real}(x::BareInterval{T}) = emptyinterval(T)
emptyinterval() = emptyinterval(precision(BareInterval)[1])
const ∅ = emptyinterval(Float64)

isempty(x::BareInterval) = x.lo == Inf && x.hi == -Inf

const ∞ = Inf

## Entire interval:
doc"""`entireinterval`s represent the whole Real line: [-∞, ∞]."""
entireinterval{T<:Real}(::Type{T}) = BareInterval{T}(-Inf, Inf)
entireinterval{T<:Real}(x::BareInterval{T}) = entireinterval(T)
entireinterval() = entireinterval(precision(BareInterval)[1])

isentire(x::BareInterval) = x.lo == -Inf && x.hi == Inf
isunbounded(x::BareInterval) = x.lo == -Inf || x.hi == Inf


# NaI: not-an-interval
doc"""`NaI` not-an-interval: [NaN, NaN]."""
nai{T<:Real}(::Type{T}) = BareInterval{T}(NaN, NaN)
nai{T<:Real}(x::BareInterval{T}) = nai(T)
nai() = nai(precision(BareInterval)[1])

isnai(x::BareInterval) = isnan(x.lo) || isnan(x.hi)

isfinite(x::BareInterval) = isfinite(x.lo) && isfinite(x.hi)
isnan(x::BareInterval) = isnai(x)

doc"""`isthin(x)` corresponds to `isSingleton`, i.e. it checks if `x` is the set consisting of a single exactly representable float. Thus any float which is not exactly representable does *not* yield a thin interval."""
function isthin(x::BareInterval)
    # (m = mid(x); m == x.lo || m == x.hi)
    x.lo == x.hi
end

doc"`iscommon(x)` checks if `x` is a **common interval**, i.e. a non-empty, bounded, real interval."
function iscommon(a::BareInterval)
    (isentire(a) || isempty(a) || isnai(a) || isunbounded(a)) && return false
    true
end

doc"`widen(x)` widens the lowest and highest bounds of `x` to the previous and next representable floating-point numbers, respectively."
widen{T<:AbstractFloat}(x::BareInterval{T}) = BareInterval(prevfloat(x.lo), nextfloat(x.hi))
