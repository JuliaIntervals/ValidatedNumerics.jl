# This file is part of the ValidatedNumerics.jl package; MIT licensed

## Promotion rules

# Avoid ambiguity with ForwardDiff:

promote_rule{T<:Real, N, R<:Real}(::Type{Interval{T}},
    ::Type{ForwardDiff.Dual{N,R}}) = ForwardDiff.Dual{N, Interval{promote_type(T,R)}}


promote_rule{T<:Real, S<:Real}(::Type{Interval{T}}, ::Type{Interval{S}}) =
    Interval{promote_type(T, S)}

promote_rule{T<:Real, S<:Real}(::Type{Interval{T}}, ::Type{S}) =
    Interval{promote_type(T, S)}

promote_rule{T<:Real}(::Type{BigFloat}, ::Type{Interval{T}}) =
    Interval{promote_type(T, BigFloat)}


function parse_decorated_string(T, s::AbstractString)
    m = match(r"(\[.*\])(\_.*)?", s)

    if m == nothing  # matched
        throw(ArgumentError("Unable to process string $x as decorated interval"))

    end

    interval_string, decoration_string = m.captures
    interval = parse_interval_string(T, interval_string)

    # type unstable:
    if decoration_string == nothing
        decoration_string = "_com"
    end

    decoration_symbol = Symbol(decoration_string[2:end])
    decoration = getfield(ValidatedNumerics, decoration_symbol)

    return DecoratedInterval(interval, decoration)

end

doc"""
`parse_interval_string` deals with strings of the form `"[3.5, 7.2]"`
"""
function parse_interval_string(T, s::AbstractString)
    if !(contains(s, "["))  # string like "3.1"

        expr = parse(s)

        # after removing support for Julia 0.4, can simplify
        # make_interval to just accept two expressions

        val = make_interval(T, expr, [expr])   # use tryparse?
        return eval(val)
    end

    # match string of form [a, b]_dec:
    m = match(r"\[(.*),(.*)\]", s)

    if m != nothing  # matched
        lo, hi = m.captures

    else

        m = match(r"\[(.*)\]", s)  # string like "[1]"

        if m == nothing
            throw(ArgumentError("Unable to process string $s as interval"))
        end

        lo = m.captures[1]
        hi = lo

    end

    expr1 = parse(lo)
    expr2 = parse(hi)

    interval = eval(make_interval(T, expr1, [expr2]))

    return interval

end


# Floating point intervals:

convert{T<:AbstractFloat}(::Type{Interval{T}}, x::AbstractString) =
    parse_interval_string(T, x)

function convert{T<:AbstractFloat, S<:Real}(::Type{Interval{T}}, x::S)
    Interval{T}( T(x, RoundDown), T(x, RoundUp) )
    # the rounding up could be done as nextfloat of the rounded down one?
    # use @round_up and @round_down here?
end

function convert{T<:AbstractFloat}(::Type{Interval{T}}, x::Float64)
    II = convert(Interval{T}, rationalize(x))
    # This prevents that rationalize(x) returns a zero when x is very small
    if x != zero(x) && II == zero(Interval{T})
        II = Interval{T}(x)
    end
    II
end

function convert{T<:AbstractFloat}(::Type{Interval{T}}, x::Interval)
    Interval{T}( T(x.lo, RoundDown), T(x.hi, RoundUp) )
end


# Complex numbers:
convert{T<:AbstractFloat}(::Type{Interval{T}}, x::Complex{Bool}) = (x == im) ?
    one(T)*im : throw(ArgumentError("Complex{Bool} not equal to im"))


# Rational intervals
function convert(::Type{Interval{Rational{Int}}}, x::Irrational)
    a = float(convert(Interval{BigFloat}, x))
    convert(Interval{Rational{Int}}, a)
end

function convert(::Type{Interval{Rational{BigInt}}}, x::Irrational)
    a = convert(Interval{BigFloat}, x)
    convert(Interval{Rational{BigInt}}, a)
end

convert{T<:Integer, S<:Integer}(::Type{Interval{Rational{T}}}, x::S) =
    Interval(x*one(Rational{T}))

convert{T<:Integer, S<:Integer}(::Type{Interval{Rational{T}}}, x::Rational{S}) =
    Interval(x*one(Rational{T}))

convert{T<:Integer, S<:Float64}(::Type{Interval{Rational{T}}}, x::S) =
    Interval(rationalize(T, x))

convert{T<:Integer, S<:BigFloat}(::Type{Interval{Rational{T}}}, x::S) =
    Interval(rationalize(T, x))


# conversion to Interval without explicit type:
function convert(::Type{Interval}, x::Real)
    T = typeof(float(x))

    return convert(Interval{T}, x)
end

convert(::Type{Interval}, x::Interval) = x
