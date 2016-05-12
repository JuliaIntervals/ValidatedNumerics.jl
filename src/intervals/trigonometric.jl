# This file is part of the ValidatedNumerics.jl package; MIT licensed

half_pi{T}(::Type{T}) = pi_interval(T) / 2
half_pi{T<:AbstractFloat}(x::T) = half_pi(T)

two_pi{T}(::Type{T})  = pi_interval(T) * 2

range_atan2{T<:Real}(::Type{T}) = BareInterval(-(pi_interval(T).hi), pi_interval(T).hi)
half_range_atan2{T}(::Type{T}) = (temp = half_pi(T); BareInterval(-(temp.hi), temp.hi) )
pos_range_atan2{T<:Real}(::Type{T}) = BareInterval(zero(T), pi_interval(T).hi)


doc"""Finds the quadrant(s) corresponding to a given floating-point
number. The quadrants are labelled as 0 for x ∈ [0, π/2], etc.
For numbers very near a boundary of the quadrant, a tuple of two quadrants
is returned. The minimum or maximum must then be chosen appropriately.

This is a rather indirect way to determine if π/2 and 3π/2 are contained
in the interval; cf. the formula for sine of an interval in
Tucker, *Validated Numerics*."""

function find_quadrants(x::AbstractFloat)
    temp = x / half_pi(x)
    (floor(Int, temp.lo), floor(Int, temp.hi))
end

function sin{T}(a::BareInterval{T})
    isempty(a) && return a

    whole_range = BareInterval(-one(T), one(T))

    diam(a) > two_pi(T).lo && return whole_range

    lo_quadrant = minimum(find_quadrants(a.lo))
    hi_quadrant = maximum(find_quadrants(a.hi))

    lo_quadrant = mod(lo_quadrant, 4)
    hi_quadrant = mod(hi_quadrant, 4)

    # Different cases depending on the two quadrants:
    if lo_quadrant == hi_quadrant
        a.hi - a.lo > pi_interval(T).lo && return whole_range  # in same quadrant but separated by almost 2pi
        lo = BareInterval(sin(a.lo, RoundDown), sin(a.lo, RoundUp))
        hi = BareInterval(sin(a.hi, RoundDown), sin(a.hi, RoundUp))
        return hull(lo, hi)

    elseif lo_quadrant==3 && hi_quadrant==0
        return BareInterval(sin(a.lo, RoundDown), sin(a.hi, RoundUp))

    elseif lo_quadrant==1 && hi_quadrant==2
        return BareInterval(sin(a.hi, RoundDown), sin(a.lo, RoundUp))

    elseif ( lo_quadrant == 0 || lo_quadrant==3 ) && ( hi_quadrant==1 || hi_quadrant==2 )
        return BareInterval(min(sin(a.lo, RoundDown), sin(a.hi, RoundDown)), one(T))

    elseif ( lo_quadrant == 1 || lo_quadrant==2 ) && ( hi_quadrant==3 || hi_quadrant==0 )
        return BareInterval(-one(T), max(sin(a.lo, RoundUp), sin(a.hi, RoundUp)))

    else#if( lo_quadrant == 0 && hi_quadrant==3 ) || ( lo_quadrant == 2 && hi_quadrant==1 )
        return whole_range
    end
end


function cos{T}(a::BareInterval{T})
    isempty(a) && return a

    whole_range = BareInterval(-one(T), one(T))

    diam(a) > two_pi(T).lo && return whole_range

    lo_quadrant = minimum(find_quadrants(a.lo))
    hi_quadrant = maximum(find_quadrants(a.hi))

    lo_quadrant = mod(lo_quadrant, 4)
    hi_quadrant = mod(hi_quadrant, 4)

    # Different cases depending on the two quadrants:
    if lo_quadrant == hi_quadrant # BareInterval limits in the same quadrant
        a.hi - a.lo > pi_interval(T).lo && return whole_range
        lo = BareInterval(cos(a.lo, RoundDown), cos(a.lo, RoundUp))
        hi = BareInterval(cos(a.hi, RoundDown), cos(a.hi, RoundUp))
        return hull(lo, hi)

    elseif lo_quadrant == 2 && hi_quadrant==3
        return BareInterval(cos(a.lo, RoundDown), cos(a.hi, RoundUp))

    elseif lo_quadrant == 0 && hi_quadrant==1
        return BareInterval(cos(a.hi, RoundDown), cos(a.lo, RoundUp))

    elseif ( lo_quadrant == 2 || lo_quadrant==3 ) && ( hi_quadrant==0 || hi_quadrant==1 )
        return BareInterval(min(cos(a.lo, RoundDown), cos(a.hi, RoundDown)), one(T))

    elseif ( lo_quadrant == 0 || lo_quadrant==1 ) && ( hi_quadrant==2 || hi_quadrant==3 )
        return BareInterval(-one(T), max(cos(a.lo, RoundUp), cos(a.hi, RoundUp)))

    else#if ( lo_quadrant == 3 && hi_quadrant==2 ) || ( lo_quadrant == 1 && hi_quadrant==0 )
        return whole_range
    end
end


function tan{T}(a::BareInterval{T})
    isempty(a) && return a

    diam(a) > pi_interval(T).lo && return entireinterval(a)

    lo_quadrant = minimum(find_quadrants(a.lo))
    hi_quadrant = maximum(find_quadrants(a.hi))

    lo_quadrant_mod = mod(lo_quadrant, 2)
    hi_quadrant_mod = mod(hi_quadrant, 2)

    if lo_quadrant_mod == 0 && hi_quadrant_mod == 1
        (half_pi(T) ⊆ a || -half_pi(T) ⊆ a) && return entireinterval(a)
    elseif lo_quadrant_mod == hi_quadrant_mod && hi_quadrant > lo_quadrant
        hi_quadrant == lo_quadrant+2 && return entireinterval(a)
    end

    BareInterval(tan(a.lo, RoundDown), tan(a.hi, RoundUp))
end

function asin{T}(a::BareInterval{T})

    domain = BareInterval(-one(T), one(T))
    a = a ∩ domain

    isempty(a) && return a

    BareInterval(asin(a.lo, RoundDown), asin(a.hi, RoundUp))
end

function acos{T}(a::BareInterval{T})

    domain = BareInterval(-one(T), one(T))
    a = a ∩ domain

    isempty(a) && return a

    BareInterval(acos(a.hi, RoundDown), acos(a.lo, RoundUp))
end


function atan{T}(a::BareInterval{T})
    isempty(a) && return a

    BareInterval(atan(a.lo, RoundDown), atan(a.hi, RoundUp))
end


#atan2{T<:Real, S<:Real}(y::BareInterval{T}, x::BareInterval{S}) = atan2(promote(y, x)...)

function atan2(y::BareInterval{Float64}, x::BareInterval{Float64})
    (isempty(y) || isempty(x)) && return emptyinterval(Float64)

    float(atan2(big53(y), big53(x)))
end

function atan2(y::BareInterval{BigFloat}, x::BareInterval{BigFloat})
    (isempty(y) || isempty(x)) && return emptyinterval(BigFloat)

    T = BigFloat

    # Prevents some non-sense results whenever y has a zero signed
    if y.lo == zero(T)
        y = BareInterval(zero(T), y.hi)
    end
    if y.hi == zero(T)
        y = BareInterval(y.lo, zero(T))
    end

    # Check cases based on x
    if x == zero(x)

        y == zero(y) && return emptyinterval(T)
        y.lo ≥ zero(T) && return half_pi(T)
        y.hi ≤ zero(T) && return -half_pi(T)
        return half_range_atan2(T)

    elseif x.lo > zero(T)

        y == zero(y) && return y
        y.lo ≥ zero(T) &&
            return @round(T, atan2(y.lo, x.hi), atan2(y.hi, x.lo)) # refinement lo bound
        y.hi ≤ zero(T) &&
            return @round(T, atan2(y.lo, x.lo), atan2(y.hi, x.hi))
        return @round(T, atan2(y.lo, x.lo), atan2(y.hi, x.lo))

    elseif x.hi < zero(T)

        y == zero(y) && return pi_interval(T)
        y.lo ≥ zero(T) &&
            return @round(T, atan2(y.hi, x.hi), atan2(y.lo, x.lo))
        y.hi < zero(T) &&
            return @round(T, atan2(y.hi, x.lo), atan2(y.lo, x.hi))
        return range_atan2(T)

    else # zero(T) ∈ x

        if x.lo == zero(T)
            y == zero(y) && return y
            y.lo ≥ zero(T) &&
                return @round(T, atan2(y.lo, x.hi), half_range_atan2(T).hi)
            y.hi ≤ zero(T) &&
                return @round(T, half_range_atan2(T).lo, atan2(y.hi, x.hi))
            return half_range_atan2(T)
        elseif x.hi == zero(T)
            y == zero(y) && return pi_interval(T)
            y.lo ≥ zero(T) &&
                return @round(T, half_pi(T).lo, atan2(y.lo, x.lo))
            y.hi < zero(T) &&
                return @round(T, atan2(y.hi, x.lo), -(half_pi(T).lo))
            return range_atan2(T)
        else
            y.lo ≥ zero(T) &&
                return @round(T, atan2(y.lo, x.hi), atan2(y.lo, x.lo))
            y.hi < zero(T) &&
                return @round(T, atan2(y.hi, x.lo), atan2(y.hi, x.hi))
            return range_atan2(T)
        end

    end
end
