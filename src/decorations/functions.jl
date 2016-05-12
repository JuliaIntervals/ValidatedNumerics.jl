# This file is part of the ValidatedNumerics.jl package; MIT licensed

# zero, one
zero{T<:Real}(a::Interval{T}) = Interval(zero(T))
zero{T<:Real}(::Type{Interval{T}}) = Interval(zero(T))
one{T<:Real}(a::Interval{T}) = Interval(one(T))
one{T<:Real}(::Type{Interval{T}}) = Interval(one(T))


## Bool functions
bool_functions = (
    :isempty, :isentire, :isunbounded,
    :isfinite, :isnai, :isnan,
    :isthin, :iscommon
)

bool_binary_functions = (
    :<, :>, :(==), :!=, :⊆, :<=,
    :interior, :isdisjoint, :precedes, :strictprecedes
)

for f in bool_functions
    @eval $(f)(xx::Interval) = $(f)(interval_part(xx))
end

for f in bool_binary_functions
    @eval $(f)(xx::Interval, yy::Interval) =
        $(f)(interval_part(xx), interval_part(yy))
end

in{T<:Real}(x::T, a::Interval) = in(x, interval_part(a))


## scalar functions: mig, mag and friends
scalar_functions = (
    :mig, :mag, :infimum, :supremum, :mid, :diam, :radius, :dist, :eps
)

for f in scalar_functions
    @eval $(f){T}(xx::Interval{T}) = $f(interval_part(xx))
end


## Arithmetic function; / is treated separately
arithm_functions = ( :+, :-, :* )

+(xx::Interval) =  xx
-(xx::Interval) =  Interval(-interval_part(xx), decoration(xx))
for f in arithm_functions
    @eval function $(f){T}(xx::Interval{T}, yy::Interval{T})
        x = interval_part(xx)
        y = interval_part(yy)
        r = $f(x, y)
        dec = min(decoration(xx), decoration(yy), decoration(r))
        Interval(r, dec)
    end
end

# Division
function inv{T}(xx::Interval{T})
    x = interval_part(xx)
    dx = decoration(xx)
    dx = zero(T) ∈ x ? min(dx,trv) : dx
    r = inv(x)
    dx = min(decoration(r), dx)
    Interval( r, dx )
end
function /{T}(xx::Interval{T}, yy::Interval{T})
    x = interval_part(xx)
    y = interval_part(yy)
    r = x / y
    dy = decoration(yy)
    dy = zero(T) ∈ y ? min(dy, trv) : dy
    dy = min(decoration(xx), dy, decoration(r))
    Interval(r, dy)
end

## fma
function fma{T}(xx::Interval{T}, yy::Interval{T}, zz::Interval{T})
    r = fma(interval_part(xx), interval_part(yy), interval_part(zz))
    d = min(decoration(xx), decoration(yy), decoration(zz))
    d = min(decoration(r), d)
    Interval(r, d)
end


# power function must be defined separately and carefully
function ^{T}(xx::Interval{T}, n::Integer)
    x = interval_part(xx)
    r = x^n
    d = min(decoration(xx), decoration(r))
    n < 0 && zero(T) ∈ x && return Interval(r, trv)
    Interval(r, d)
end

function ^{T}(xx::Interval{T}, q::AbstractFloat)
    x = interval_part(xx)
    r = x^q
    d = min(decoration(xx), decoration(r))
    if x > zero(T) || (x.lo ≥ zero(T) && q > zero(T)) ||
            (isinteger(q) && q > zero(q)) || (isinteger(q) && zero(T) ∉ x)
        return Interval(r, d)
    end
    Interval(r, trv)
end

function ^{T, S<:Integer}(xx::Interval{T}, q::Rational{S})
    x = interval_part(xx)
    r = x^q
    d = min(decoration(xx), decoration(r))
    if x > zero(T) || (x.lo ≥ zero(T) && q > zero(T)) ||
            (isinteger(q) && q > zero(q)) || (isinteger(q) && zero(T) ∉ x)
        return Interval(r, d)
    end
    Interval(r, trv)
end

function ^{T,S}(xx::Interval{T}, qq::Interval{S})
    x = interval_part(xx)
    q = interval_part(qq)
    r = x^q
    d = min(decoration(xx), decoration(qq), decoration(r))
    if x > zero(T) || (x.lo ≥ zero(T) && q.lo > zero(T)) ||
            (isthin(q) && isinteger(q.lo) && q.lo > zero(q)) ||
            (isthin(q) && isinteger(q.lo) && zero(T) ∉ x)
        return Interval(r, d)
    end
    Interval(r, trv)
end

## Discontinuous functions (sign, ceil, floor, trunc) and round
function sign{T}(xx::Interval{T})
    r = sign(interval_part(xx))
    d = decoration(xx)
    isthin(r) && return Interval(r, d)
    Interval(r, min(d,def))
end
function ceil{T}(xx::Interval{T})
    x = interval_part(xx)
    r = ceil(x)
    d = decoration(xx)
    if isinteger(x.hi)
        d = min(d, dac)
    end
    isthin(r) && return Interval(r, d)
    Interval(r, min(d,def))
end
function floor{T}(xx::Interval{T})
    x = interval_part(xx)
    r = floor(x)
    d = decoration(xx)
    if isinteger(x.lo)
        d = min(d, dac)
    end
    isthin(r) && return Interval(r, d)
    Interval(r, min(d,def))
end
function trunc{T}(xx::Interval{T})
    x = interval_part(xx)
    r = trunc(x)
    d = decoration(xx)
    if (isinteger(x.lo) && x.lo < zero(T)) || (isinteger(x.hi) && x.hi > zero(T))
        d = min(d, dac)
    end
    isthin(r) && return Interval(r, d)
    Interval(r, min(d,def))
end

function round(xx::Interval, ::RoundingMode{:Nearest})
    x = interval_part(xx)
    r = round(x)
    d = decoration(xx)
    if isinteger(2*x.lo) || isinteger(2*x.hi)
        d = min(d, dac)
    end
    isthin(r) && return Interval(r, d)
    Interval(r, min(d,def))
end
function round(xx::Interval, ::RoundingMode{:NearestTiesAway})
    x = interval_part(xx)
    r = round(x,RoundNearestTiesAway)
    d = decoration(xx)
    if isinteger(2*x.lo) || isinteger(2*x.hi)
        d = min(d, dac)
    end
    isthin(r) && return Interval(r, d)
    Interval(r, min(d,def))
end
round(xx::Interval) = round(xx, RoundNearest)
round(xx::Interval, ::RoundingMode{:ToZero}) = trunc(xx)
round(xx::Interval, ::RoundingMode{:Up}) = ceil(xx)
round(xx::Interval, ::RoundingMode{:Down}) = floor(xx)


## Define binary functions with no domain restrictions
binary_functions = ( :min, :max )

for f in binary_functions
    @eval function $(f){T}(xx::Interval{T}, yy::Interval{T})
        r = $f(interval_part(xx), interval_part(yy))
        d = min(decoration(r), decoration(xx), decoration(yy))
        Interval(r, d)
    end
end

## abs
abs{T}(xx::Interval{T}) =
    Interval(abs(interval_part(xx)), decoration(xx))


## Other (cancel and set) functions
other_functions = ( :cancelplus, :cancelminus, :intersect, :hull, :union )

for f in other_functions
    @eval $(f){T}(xx::Interval{T}, yy::Interval{T}) =
        Interval($(f)(interval_part(xx), interval_part(yy)), trv)
end

@doc """
    cancelplus(xx, yy)

Interval interval extension; the result is decorated as `trv`,
following the IEEE-1788 Standard (see Sect. 11.7.1, pp 47).
""" cancelplus

@doc """
    cancelminus(xx, yy)

Interval interval extension; the result is decorated as `trv`,
following the IEEE-1788 Standard (see Sect. 11.7.1, pp 47).
""" cancelminus

@doc """
    intersect(xx, yy)

Interval interval extension; the result is decorated as `trv`,
following the IEEE-1788 Standard (see Sect. 11.7.1, pp 47).
""" intersect

@doc """
    hull(xx, yy)

Interval interval extension; the result is decorated as `trv`,
following the IEEE-1788 Standard (see Sect. 11.7.1, pp 47).
""" hull

@doc """
    union(xx, yy)

Interval interval extension; the result is decorated as `trv`,
following the IEEE-1788 Standard (see Sect. 11.7.1, pp 47).
""" union


## Functions on unrestricted domains; tan and atan2 are treated separately
unrestricted_functions =(
    :exp, :exp2, :exp10,
    :sin, :cos,
    :atan,
    :sinh, :cosh, :tanh,
    :asinh )

for f in unrestricted_functions
    @eval function $(f){T}(xx::Interval{T})
        x = interval_part(xx)
        r = $f(x)
        d = min(decoration(r), decoration(xx))
        Interval(r, d)
    end
end

function tan{T}(xx::Interval{T})
    x = interval_part(xx)
    r = tan(x)
    d = min(decoration(r), decoration(xx))
    if isunbounded(r)
        d = min(d, trv)
    end
    Interval(r, d)
end

function decay(a::DECORATION)
    a == com && return dac
    a == dac && return def
    a == def && return trv
    a == trv && return trv
    ill
end

function atan2{T}(yy::Interval{T}, xx::Interval{T})
    x = interval_part(xx)
    y = interval_part(yy)
    r = atan2(y, x)
    d = decoration(r)
    d = min(d, decoration(xx), decoration(yy))
    # Check cases when decoration is trv and decays (from com or dac)
    if zero(T) ∈ y
        zero(T) ∈ x && return Interval(r, trv)
        if x.hi < zero(T) && y.lo != y.hi && signbit(y.lo) && Int(d) > 2
            return Interval(r, decay(d))
        end
    end
    Interval(r, d)
end


# For domains, cf. table 9.1 on page 28 of the standard
# Functions with restricted domains:

# The function is unbounded at the bounded edges of the domain
restricted_functions1 = Dict(
    :log   => [0, ∞],
    :log2  => [0, ∞],
    :log10 => [0, ∞],
    :atanh => [-1, 1]
)

# The function is bounded at the bounded edge(s) of the domain
restricted_functions2 = Dict(
    :sqrt  => [0, ∞],
    :asin  => [-1, 1],
    :acos  => [-1, 1],
    :acosh => [1, ∞]
)

# Define functions with restricted domains on Interval's:
for (f, domain) in restricted_functions1
    domain = BareInterval(domain...)
    @eval function Base.$(f){T}(xx::Interval{T})
        x = interval_part(xx)
        r = $(f)(x)
        d = min(decoration(xx), decoration(r))
        x ⪽ $(domain) && return Interval(r, d)
        Interval(r, trv)
    end
end

for (f, domain) in restricted_functions2
    domain = BareInterval(domain...)
    @eval function Base.$(f){T}(xx::Interval{T})
        x = interval_part(xx)
        r = $(f)(x)
        d = min(decoration(xx), decoration(r))
        x ⊆ $(domain) && return Interval(r, d)
        Interval(r, trv)
    end
end
