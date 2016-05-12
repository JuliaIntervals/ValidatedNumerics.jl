# This file is part of the ValidatedNumerics.jl package; MIT licensed

## Promotion

## Promotion rules
promote_rule{T<:Real, S<:Real}(::Type{BareInterval{T}}, ::Type{BareInterval{S}}) =
    BareInterval{promote_type(T, S)}

promote_rule{T<:Real, S<:Real}(::Type{BareInterval{T}}, ::Type{S}) =
    BareInterval{promote_type(T, S)}

promote_rule{T<:Real}(::Type{BigFloat}, ::Type{BareInterval{T}}) =
    BareInterval{promote_type(T, BigFloat)}


## Conversion rules

# convert{T<:Real}(::Type{BareInterval}, x::T) = convert(BareInterval{Float64}, x)

doc"""`split_interval_string` deals with strings of the form
\"[3.5, 7.2]\""""

function split_interval_string(T, x::AbstractString)
    if !(contains(x, "["))  # string like "3.1"
        return @thin_round(T, parse(T, x))
    end

    m = match(r"\[(.*),(.*)\]", x)  # string like "[1, 2]"

    if m == nothing
        throw(ArgumentError("Unable to process string $x as interval"))
    end

    @round(T, parse(T, m.captures[1]), parse(T, m.captures[2]))
end


# Floating point intervals:

convert{T<:AbstractFloat}(::Type{BareInterval{T}}, x::AbstractString) =
    split_interval_string(T, x)

function convert{T<:AbstractFloat, S<:Real}(::Type{BareInterval{T}}, x::S)
    BareInterval{T}( T(x, RoundDown), T(x, RoundUp) )
    # the rounding up could be down as nextfloat of the rounded down one
end

function convert{T<:AbstractFloat}(::Type{BareInterval{T}}, x::Float64)
    convert(BareInterval{T}, rationalize(x))
end

function convert{T<:AbstractFloat}(::Type{BareInterval{T}}, x::BareInterval)
    BareInterval{T}( T(x.lo, RoundDown), T(x.hi, RoundUp) )
end


# Complex numbers:
convert{T<:AbstractFloat}(::Type{BareInterval{T}}, x::Complex{Bool}) = (x == im) ?
    one(T)*im : throw(ArgumentError("Complex{Bool} not equal to im"))


# Rational intervals
function convert(::Type{BareInterval{Rational{Int}}}, x::Irrational)
    a = float(convert(BareInterval{BigFloat}, x))
    convert(BareInterval{Rational{Int}}, a)
end

function convert(::Type{BareInterval{Rational{BigInt}}}, x::Irrational)
    a = convert(BareInterval{BigFloat}, x)
    convert(BareInterval{Rational{BigInt}}, a)
end

convert{T<:Integer, S<:Integer}(::Type{BareInterval{Rational{T}}}, x::S) =
    BareInterval(x*one(Rational{T}))

convert{T<:Integer, S<:Integer}(::Type{BareInterval{Rational{T}}}, x::Rational{S}) =
    BareInterval(x*one(Rational{T}))

convert{T<:Integer, S<:Float64}(::Type{BareInterval{Rational{T}}}, x::S) =
    BareInterval(rationalize(T, x))

convert{T<:Integer, S<:BigFloat}(::Type{BareInterval{Rational{T}}}, x::S) =
    BareInterval(rationalize(T, x))
