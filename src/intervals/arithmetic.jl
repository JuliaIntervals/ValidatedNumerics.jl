# This file is part of the ValidatedNumerics.jl package; MIT licensed

"""
    in(x, a)
    ∈(x, a)

Checks if the number `x` is a member of the interval `a`, treated as a set.
Corresponds to `isMember` in the ITF-1788 Standard.
"""
function in{T<:Real}(x::T, a::BareInterval)
    isinf(x) && return false
    a.lo <= x <= a.hi
end


## Comparisons

"""
    ==(a,b)

Checks if the intervals `a` and `b` are equal.
"""
function ==(a::BareInterval, b::BareInterval)
    isempty(a) && isempty(b) && return true
    a.lo == b.lo && a.hi == b.hi
end
!=(a::BareInterval, b::BareInterval) = !(a==b)

"""
    issubset(a,b)
    ⊆(a,b)

Checks if all the points of the interval `a` are within the interval `b`.
"""
function ⊆(a::BareInterval, b::BareInterval)
    isempty(a) && return true
    b.lo ≤ a.lo && a.hi ≤ b.hi
end

# Auxiliary functions: equivalent to </<=, but Inf <,<= Inf returning true
function islessprime{T<:Real}(a::T, b::T)
    (isinf(a) || isinf(b)) && a==b && return true
    a < b
end

# Interior
function interior(a::BareInterval, b::BareInterval)
    isempty(a) && return true
    islessprime(b.lo, a.lo) && islessprime(a.hi, b.hi)
end
const ⪽ = interior  # \subsetdot

# Disjoint:
function isdisjoint(a::BareInterval, b::BareInterval)
    (isempty(a) || isempty(b)) && return true
    islessprime(b.hi, a.lo) || islessprime(a.hi, b.lo)
end

# Weakly less, \le, <=
function <=(a::BareInterval, b::BareInterval)
    isempty(a) && isempty(b) && return true
    (isempty(a) || isempty(b)) && return false
    (a.lo ≤ b.lo) && (a.hi ≤ b.hi)
end

# Strict less: <
function <(a::BareInterval, b::BareInterval)
    isempty(a) && isempty(b) && return true
    (isempty(a) || isempty(b)) && return false
    islessprime(a.lo, b.lo) && islessprime(a.hi, b.hi)
end

# precedes
function precedes(a::BareInterval, b::BareInterval)
    (isempty(a) || isempty(b)) && return true
    a.hi ≤ b.lo
end

# strictpreceds
function strictprecedes(a::BareInterval, b::BareInterval)
    (isempty(a) || isempty(b)) && return true
    # islessprime(a.hi, b.lo)
    a.hi < b.lo
end
const ≺ = strictprecedes # \prec


# zero, one
zero{T<:Real}(a::BareInterval{T}) = BareInterval(zero(T))
zero{T<:Real}(::Type{BareInterval{T}}) = BareInterval(zero(T))
one{T<:Real}(a::BareInterval{T}) = BareInterval(one(T))
one{T<:Real}(::Type{BareInterval{T}}) = BareInterval(one(T))


## Addition and subtraction

+(a::BareInterval) = a
-(a::BareInterval) = BareInterval(-a.hi, -a.lo)

function +{T<:Real}(a::BareInterval{T}, b::BareInterval{T})
    (isempty(a) || isempty(b)) && return emptyinterval(T)
    @round(T, a.lo + b.lo, a.hi + b.hi)
end

function -{T<:Real}(a::BareInterval{T}, b::BareInterval{T})
    (isempty(a) || isempty(b)) && return emptyinterval(T)
    @round(T, a.lo - b.hi, a.hi - b.lo)
end


## Multiplication

function *{T<:Real}(a::BareInterval{T}, b::BareInterval{T})
    (isempty(a) || isempty(b)) && return emptyinterval(T)

    (a == zero(a) || b == zero(b)) && return zero(a)

    if b.lo >= zero(T)
        a.lo >= zero(T) && return @round(T, a.lo*b.lo, a.hi*b.hi)
        a.hi <= zero(T) && return @round(T, a.lo*b.hi, a.hi*b.lo)
        return @round(T, a.lo*b.hi, a.hi*b.hi)   # zero(T) ∈ a
    elseif b.hi <= zero(T)
        a.lo >= zero(T) && return @round(T, a.hi*b.lo, a.lo*b.hi)
        a.hi <= zero(T) && return @round(T, a.hi*b.hi, a.lo*b.lo)
        return @round(T, a.hi*b.lo, a.lo*b.lo)   # zero(T) ∈ a
    else
        a.lo > zero(T) && return @round(T, a.hi*b.lo, a.hi*b.hi)
        a.hi < zero(T) && return @round(T, a.lo*b.hi, a.lo*b.lo)
        return @round(T, min(a.lo*b.hi, a.hi*b.lo), max(a.lo*b.lo, a.hi*b.hi))
    end
end


## Division

function inv{T<:Real}(a::BareInterval{T})
    isempty(a) && return emptyinterval(a)

    if zero(T) ∈ a
        a.lo < zero(T) == a.hi && return @round(T, -Inf, inv(a.lo))
        a.lo == zero(T) < a.hi && return @round(T, inv(a.hi), Inf)
        a.lo < zero(T) < a.hi && return entireinterval(T)
        a == zero(a) && return emptyinterval(T)
    end

    @round(T, inv(a.hi), inv(a.lo))
end

function /{T<:Real}(a::BareInterval{T}, b::BareInterval{T})

    S = typeof(a.lo / b.lo)
    (isempty(a) || isempty(b)) && return emptyinterval(S)
    b == zero(b) && return emptyinterval(S)

    if b.lo > zero(T) # b strictly positive

        a.lo >= zero(T) && return @round(S, a.lo/b.hi, a.hi/b.lo)
        a.hi <= zero(T) && return @round(S, a.lo/b.lo, a.hi/b.hi)
        return @round(S, a.lo/b.lo, a.hi/b.lo)  # zero(T) ∈ a

    elseif b.hi < zero(T) # b strictly negative

        a.lo >= zero(T) && return @round(S, a.hi/b.hi, a.lo/b.lo)
        a.hi <= zero(T) && return @round(S, a.hi/b.lo, a.lo/b.hi)
        return @round(S, a.hi/b.hi, a.lo/b.hi)  # zero(T) ∈ a

    else   # b contains zero, but is not zero(b)

        a == zero(a) && return zero(BareInterval{S})

        if b.lo == zero(T)

            a.lo >= zero(T) && return @round(S, a.lo/b.hi, Inf)
            a.hi <= zero(T) && return @round(S, -Inf, a.hi/b.hi)
            return entireinterval(S)

        elseif b.hi == zero(T)

            a.lo >= zero(T) && return @round(S, -Inf, a.lo/b.lo)
            a.hi <= zero(T) && return @round(S, a.hi/b.lo, Inf)
            return entireinterval(S)

        else

            return entireinterval(S)

        end
    end
end

//(a::BareInterval, b::BareInterval) = a / b    # to deal with rationals


## fma: fused multiply-add
function fma{T}(a::BareInterval{T}, b::BareInterval{T}, c::BareInterval{T})
    #T = promote_type(eltype(a), eltype(b), eltype(c))

    (isempty(a) || isempty(b) || isempty(c)) && return emptyinterval(T)

    if isentire(a)
        b == zero(b) && return c
        return entireinterval(T)
    elseif isentire(b)
        a == zero(a) && return c
        return entireinterval(T)
    end

    lo = setrounding(T, RoundDown) do
        lo1 = fma(a.lo, b.lo, c.lo)
        lo2 = fma(a.lo, b.hi, c.lo)
        lo3 = fma(a.hi, b.lo, c.lo)
        lo4 = fma(a.hi, b.hi, c.lo)
        min(lo1, lo2, lo3, lo4)
    end
    hi = setrounding(T, RoundUp) do
        hi1 = fma(a.lo, b.lo, c.hi)
        hi2 = fma(a.lo, b.hi, c.hi)
        hi3 = fma(a.hi, b.lo, c.hi)
        hi4 = fma(a.hi, b.hi, c.hi)
        max(hi1, hi2, hi3, hi4)
    end
    BareInterval(lo, hi)
end


## Scalar functions on intervals (no directed rounding used)

function mag{T<:Real}(a::BareInterval{T})
    isempty(a) && return convert(eltype(a), NaN)
    # r1, r2 = setrounding(T, RoundUp) do
    #     abs(a.lo), abs(a.hi)
    # end
    max( abs(a.lo), abs(a.hi) )
end

function mig{T<:Real}(a::BareInterval{T})
    isempty(a) && return convert(eltype(a), NaN)
    zero(a.lo) ∈ a && return zero(a.lo)
    r1, r2 = setrounding(T, RoundDown) do
        abs(a.lo), abs(a.hi)
    end
    min( r1, r2 )
end


# Infimum and supremum of an interval
infimum(a::BareInterval) = a.lo
supremum(a::BareInterval) = a.hi


## Functions needed for generic linear algebra routines to work
real(a::BareInterval) = a

function abs(a::BareInterval)
    isempty(a) && return emptyinterval(a)
    BareInterval(mig(a), mag(a))
end

function min(a::BareInterval, b::BareInterval)
    (isempty(a) || isempty(b)) && return emptyinterval(a)
    BareInterval( min(a.lo, b.lo), min(a.hi, b.hi))
end

function max(a::BareInterval, b::BareInterval)
    (isempty(a) || isempty(b)) && return emptyinterval(a)
    BareInterval( max(a.lo, b.lo), max(a.hi, b.hi))
end


## Set operations
"""
    intersect(a, b)
    ∩(a,b)

Returns the intersection of the intervals `a` and `b`, considered as
(extended) sets of real numbers. That is, the set that contains
the points common in `a` and `b`.
"""
function intersect{T}(a::BareInterval{T}, b::BareInterval{T})
    isdisjoint(a,b) && return emptyinterval(T)

    BareInterval(max(a.lo, b.lo), min(a.hi, b.hi))
end
# Specific promotion rule for intersect:
intersect{T,S}(a::BareInterval{T}, b::BareInterval{S}) = intersect(promote(a,b)...)


## Hull
"""
    hull(a, b)

Returns the "convex hull" of the intervals `a` and `b`, considered as
(extended) sets of real numbers. That is, the minimum set that contains
all points in `a` and `b`.
"""
hull{T}(a::BareInterval{T}, b::BareInterval{T}) = BareInterval(min(a.lo, b.lo), max(a.hi, b.hi))

"""
    union(a, b)
    ∪(a,b)

Returns the union (convex hull) of the intervals `a` and `b`; it is equivalent
to `hull(a,b)`.
"""
union(a::BareInterval, b::BareInterval) = hull(a, b)


dist(a::BareInterval, b::BareInterval) = max(abs(a.lo-b.lo), abs(a.hi-b.hi))
eps(a::BareInterval) = max(eps(a.lo), eps(a.hi))


## floor, ceil, trunc, sign, roundTiesToEven, roundTiesToAway
function floor(a::BareInterval)
    isempty(a) && return emptyinterval(a)
    BareInterval(floor(a.lo), floor(a.hi))
end

function ceil(a::BareInterval)
    isempty(a) && return emptyinterval(a)
    BareInterval(ceil(a.lo), ceil(a.hi))
end

function trunc(a::BareInterval)
    isempty(a) && return emptyinterval(a)
    BareInterval(trunc(a.lo), trunc(a.hi))
end

function sign{T<:Real}(a::BareInterval{T})
    isempty(a) && return emptyinterval(a)

    a == zero(a) && return a
    if a ≤ zero(a)
        zero(T) ∈ a && return BareInterval(-one(T), zero(T))
        return BareInterval(-one(T))
    elseif a ≥ zero(a)
        zero(T) ∈ a && return BareInterval(zero(T), one(T))
        return BareInterval(one(T))
    end
    return BareInterval(-one(T), one(T))
end

# RoundTiesToEven is an alias of `RoundNearest`
const RoundTiesToEven = RoundNearest
# RoundTiesToAway is an alias of `RoundNearestTiesAway`
const RoundTiesToAway = RoundNearestTiesAway

"""
    round(a::BareInterval[, RoundingMode])

Returns the interval with rounded to an interger limits.

For compliance with the IEEE Std 1788-2015, "roundTiesToEven" corresponds
to `round(a)` or `round(a, RoundNearest)`, and "roundTiesToAway"
to `round(a, RoundNearestTiesAway)`.
"""
round(a::BareInterval) = round(a, RoundNearest)
round(a::BareInterval, ::RoundingMode{:ToZero}) = trunc(a)
round(a::BareInterval, ::RoundingMode{:Up}) = ceil(a)
round(a::BareInterval, ::RoundingMode{:Down}) = floor(a)

function round(a::BareInterval, ::RoundingMode{:Nearest})
    isempty(a) && return emptyinterval(a)
    BareInterval(round(a.lo), round(a.hi))
end

function round(a::BareInterval, ::RoundingMode{:NearestTiesAway})
    isempty(a) && return emptyinterval(a)
    BareInterval(round(a.lo, RoundNearestTiesAway), round(a.hi, RoundNearestTiesAway))
end

# mid, diam, radius
function mid(a::BareInterval)
    isentire(a) && return zero(a.lo)
    (a.lo + a.hi) / 2
end

function diam{T<:Real}(a::BareInterval{T})
    isempty(a) && return convert(T, NaN)
    @setrounding(T, a.hi - a.lo, RoundUp) #cf page 64 of IEEE1788
end

# Should `radius` this yield diam(a)/2? This affects other functions!
function radius(a::BareInterval)
    isempty(a) && return convert(eltype(a), NaN)
    m = mid(a)
    max(m - a.lo, a.hi - m)
end

# cancelplus and cancelminus
"""
    cancelminus(a, b)

Return the unique interval `c` such that `b+c=a`.
"""
function cancelminus(a::BareInterval, b::BareInterval)
    T = promote_type(eltype(a), eltype(b))

    (isempty(a) && (isempty(b) || !isunbounded(b))) && return emptyinterval(T)

    (isunbounded(a) || isunbounded(b) || isempty(b)) && return entireinterval(T)

    a.lo - b.lo > a.hi - b.hi && return entireinterval(T)

    # The following is needed to avoid finite precision problems
    ans = false
    if diam(a) == diam(b)
        prec = T == Float64 ? 128 : 128+precision(BigFloat)
        ans = setprecision(prec) do
            diam(@biginterval(a)) < diam(@biginterval(b))
        end
    end
    ans && return entireinterval(T)

    @round(T, a.lo - b.lo, a.hi - b.hi)
end

"""
    cancelplus(a, b)

Returns the unique interval `c` such that `b-c=a`;
it is equivalent to `cancelminus(a, −b)`.
"""
cancelplus(a::BareInterval, b::BareInterval) = cancelminus(a, -b)


# midpoint-radius forms
midpoint_radius(a::BareInterval) = (mid(a), radius(a))

interval_from_midpoint_radius(midpoint, radius) = BareInterval(midpoint-radius, midpoint+radius)
