# This file is part of the ValidatedNumerics.jl package; MIT licensed

# Interval intervals, following the IEEE 1758-2015 standard

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
    Interval

A `Interval` is an interval, together with a *decoration*, i.e.
a flag that records the status of the interval when thought of as the result
of a previously executed sequence of functions acting on an initial interval.
"""
type Interval{T<:Real} <: AbstractBareInterval
    interval::BareInterval{T}
    decoration::DECORATION

    function Interval(I::BareInterval, d::DECORATION)
        dd = decoration(I)
        dd <= trv && return new(I, dd)
        d == ill && return new(nai(I), d)
        return new(I, d)
    end
end

Interval{T<:AbstractFloat}(I::BareInterval{T}, d::DECORATION) =
    Interval{T}(I, d)
Interval{T<:Real}(a::T, b::T, d::DECORATION) =
    Interval(BareInterval(a,b), d)
Interval{T<:Real}(a::T, d::DECORATION) = Interval(BareInterval(a,a), d)
Interval(a::Tuple, d::DECORATION) = Interval(BareInterval(a...), d)
Interval{T<:Real, S<:Real}(a::T, b::S, d::DECORATION) =
    Interval(BareInterval(promote(a,b)...), d)

# Automatic decorations for an interval
Interval(I::BareInterval) = Interval(I, decoration(I))
Interval{T<:Real}(a::T, b::T) = Interval(BareInterval(a,b))
Interval{T<:Real}(a::T) = Interval(BareInterval(a,a))
Interval(a::Tuple) = Interval(BareInterval(a...))
Interval{T<:Real, S<:Real}(a::T, b::S) = Interval(BareInterval(a,b))

Interval(I::Interval, dec::DECORATION) = Interval(I.interval, dec)

interval_part(x::Interval) = x.interval
decoration(x::Interval) = x.decoration

# Automatic decorations for an BareInterval
function decoration(I::BareInterval)
    isnai(I) && return ill           # nai()
    isempty(I) && return trv         # emptyinterval
    isunbounded(I) && return dac     # unbounded
    com                              # common
end

# Promotion and conversion, and other constructors
promote_rule{T<:Real, S<:Real}(::Type{Interval{T}}, ::Type{S}) =
    Interval{promote_type(T, S)}
promote_rule{T<:Real, S<:Real}(::Type{Interval{T}}, ::Type{Interval{S}}) =
    Interval{promote_type(T, S)}

convert{T<:Real, S<:Real}(::Type{Interval{T}}, x::S) =
    Interval( BareInterval(T(x, RoundDown), T(x, RoundUp)) )
convert{T<:Real, S<:Integer}(::Type{Interval{T}}, x::S) =
    Interval( BareInterval(T(x), T(x)) )
# function convert{T<:AbstractFloat}(::Type{Interval{T}}, x::Float64)
#     convert(Interval{T}, rationalize(x))
# end
function convert{T<:Real}(::Type{Interval{T}}, xx::Interval)
    x = interval_part(xx)
    x = convert(BareInterval{T},x)
    Interval( x, decoration(xx) )
end


# show(io::IO, x::Interval) = print(io, x.interval, "_", x.decoration)

macro decorated(ex...)
    local x

    if length(ex) == 1
        x = :(@interval($(esc(ex[1]))))
    else
        x = :(@interval($(esc(ex[1])), $(esc(ex[2]))))
    end

    :(Interval($x))
end
