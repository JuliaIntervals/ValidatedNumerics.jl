# This file is part of the ValidatedNumerics.jl package; MIT licensed

type BareIntervalParameters

    precision_type::Type
    precision::Int
    rounding::Symbol
    pi::BareInterval{BigFloat}

    BareIntervalParameters() = new(BigFloat, 256, :narrow)  # leave out pi
end

const parameters = BareIntervalParameters()


## Precision:

doc"`big53` creates an equivalent `BigFloat` interval to a given `Float64` interval."
function big53(a::BareInterval{Float64})
    x = setprecision(BareInterval, 53) do  # precision of Float64
        convert(BareInterval{BigFloat}, a)
    end
end


setprecision(::Type{BareInterval}, ::Type{Float64}) = parameters.precision_type = Float64
# does not change the BigFloat precision


function setprecision{T<:AbstractFloat}(::Type{BareInterval}, ::Type{T}, prec::Integer)
    #println("SETTING BIGFLOAT PRECISION TO $precision")
    setprecision(BigFloat, prec)

    parameters.precision_type = T
    parameters.precision = prec
    parameters.pi = convert(BareInterval{BigFloat}, pi)

    prec
end

setprecision{T<:AbstractFloat}(::Type{BareInterval{T}}, prec) = setprecision(BareInterval, T, prec)

setprecision(::Type{BareInterval}, prec::Integer) = setprecision(BareInterval, BigFloat, prec)

function setprecision(f::Function, ::Type{BareInterval}, prec::Integer)

    old_precision = precision(BareInterval)
    setprecision(BareInterval, prec)

    try
        return f()
    finally
        setprecision(BareInterval, old_precision)
    end
end

# setprecision(::Type{BareInterval}, precision) = setprecision(BareInterval, precision)
setprecision(::Type{BareInterval}, t::Tuple) = setprecision(BareInterval, t...)

precision(::Type{BareInterval}) = (parameters.precision_type, parameters.precision)


const float_interval_pi = convert(BareInterval{Float64}, pi)  # does not change

pi_interval(::Type{BigFloat}) = parameters.pi
pi_interval(::Type{Float64})  = float_interval_pi


# Rounding for rational intervals, e.g for sqrt of rational interval:
# Find the corresponding AbstractFloat type for a given rational type

Base.float{T}(::Type{Rational{T}}) = typeof(float(one(Rational{T})))

# better to just do the following ?
# Base.float(::Type{Rational{Int64}}) = Float64
# Base.float(::Type{Rational{BigInt}}) = BigFloat

# Use that type for rounding with rationals, e.g. for sqrt:

if VERSION < v"0.5.0-dev+1182"

    function Base.with_rounding{T}(f::Function, ::Type{Rational{T}},
        rounding_mode::RoundingMode)
        setrounding(f, float(Rational{T}), rounding_mode)
    end

else
    function Base.setrounding{T}(f::Function, ::Type{Rational{T}},
        rounding_mode::RoundingMode)
        setrounding(f, float(Rational{T}), rounding_mode)
    end
end


float(x::BareInterval) =
    # @round(BigFloat, convert(Float64, x.lo), convert(Float64, x.hi))
    convert(BareInterval{Float64}, x)

## Change type of interval rounding:


doc"""`rounding(BareInterval)` returns the current interval rounding mode.
There are two possible rounding modes:

- :narrow  -- changes the floating-point rounding mode to `RoundUp` and `RoundDown`.
This gives the narrowest possible interval.

- :wide -- Leaves the floating-point rounding mode in `RoundNearest` and uses
`prevfloat` and `nextfloat` to achieve directed rounding. This creates an interval of width 2`eps`.
"""

rounding(::Type{BareInterval}) = parameters.rounding

function setrounding(::Type{BareInterval}, mode)
    if mode ∉ [:wide, :narrow]
        throw(ArgumentError("Only possible interval rounding modes are `:wide` and `:narrow`"))
    end

    parameters.rounding = mode  # a symbol
end

big{T}(x::BareInterval{T}) = convert(BareInterval{BigFloat}, x)
