# This file is part of the ValidatedNumerics.jl package; MIT licensed

# Decorated intervals, following the IEEE 1758-2015 standard

"""
    DECORATION

Enumeration constant for the types of interval decorations.
The nomenclature of the follows the IEEE-1788 (2015) standard
(sect 11.2):

- `com -> 4`: common: bounded, non-empty
- `dac -> 3`: defined (nonempty) and continuous
- `def -> 2`: defined (nonempty)
- `trv -> 1`: always true (no information)
- `ill -> 0`: nai ("not an interval")
"""
@enum DECORATION ill=0 trv=1 def=2 dac=3 com=4
# Note that `isless`, and hence ``<` and `min`, are automatically defined for enums

"""
    Decorated

A `Decorated` is an interval, together with a *decoration*, i.e.
a flag that records the status of the interval when thought of as the result
of a previously executed sequence of functions acting on an initial interval.
"""
type Decorated{T<:Real} <: AbstractBareInterval
    interval::BareInterval{T}
    decoration::DECORATION

    function Decorated(I::BareInterval, d::DECORATION)
        dd = decoration(I)
        dd <= trv && return new(I, dd)
        d == ill && return new(nai(I), d)
        return new(I, d)
    end
end

Decorated{T<:AbstractFloat}(I::BareInterval{T}, d::DECORATION) =
    Decorated{T}(I, d)
Decorated{T<:Real}(a::T, b::T, d::DECORATION) =
    Decorated(BareInterval(a,b), d)
Decorated{T<:Real}(a::T, d::DECORATION) = Decorated(BareInterval(a,a), d)
Decorated(a::Tuple, d::DECORATION) = Decorated(BareInterval(a...), d)
Decorated{T<:Real, S<:Real}(a::T, b::S, d::DECORATION) =
    Decorated(BareInterval(promote(a,b)...), d)

# Automatic decorations for an interval
Decorated(I::BareInterval) = Decorated(I, decoration(I))
Decorated{T<:Real}(a::T, b::T) = Decorated(BareInterval(a,b))
Decorated{T<:Real}(a::T) = Decorated(BareInterval(a,a))
Decorated(a::Tuple) = Decorated(BareInterval(a...))
Decorated{T<:Real, S<:Real}(a::T, b::S) = Decorated(BareInterval(a,b))

Decorated(I::Decorated, dec::DECORATION) = Decorated(I.interval, dec)

interval_part(x::Decorated) = x.interval
decoration(x::Decorated) = x.decoration

# Automatic decorations for an BareInterval
function decoration(I::BareInterval)
    isnai(I) && return ill           # nai()
    isempty(I) && return trv         # emptyinterval
    isunbounded(I) && return dac     # unbounded
    com                              # common
end

# Promotion and conversion, and other constructors
promote_rule{T<:Real, S<:Real}(::Type{Decorated{T}}, ::Type{S}) =
    Decorated{promote_type(T, S)}
promote_rule{T<:Real, S<:Real}(::Type{Decorated{T}}, ::Type{Decorated{S}}) =
    Decorated{promote_type(T, S)}

convert{T<:Real, S<:Real}(::Type{Decorated{T}}, x::S) =
    Decorated( BareInterval(T(x, RoundDown), T(x, RoundUp)) )
convert{T<:Real, S<:Integer}(::Type{Decorated{T}}, x::S) =
    Decorated( BareInterval(T(x), T(x)) )
# function convert{T<:AbstractFloat}(::Type{Decorated{T}}, x::Float64)
#     convert(Decorated{T}, rationalize(x))
# end
function convert{T<:Real}(::Type{Decorated{T}}, xx::Decorated)
    x = interval_part(xx)
    x = convert(BareInterval{T},x)
    Decorated( x, decoration(xx) )
end


# show(io::IO, x::Decorated) = print(io, x.interval, "_", x.decoration)

macro decorated(ex...)
    local x

    if length(ex) == 1
        x = :(@interval($(esc(ex[1]))))
    else
        x = :(@interval($(esc(ex[1])), $(esc(ex[2]))))
    end

    :(Decorated($x))
end
