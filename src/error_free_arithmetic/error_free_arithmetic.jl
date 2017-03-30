# Error-free arithmetic operations from
# "Tight and rigourous error bounds for basic building blocks of double-word arithmetic", by
# Mioara Joldes, Valentina Popescu, Jean-Michel Muller

module ErrorFreeArithmetic

using ValidatedNumerics
using BenchmarkTools

import ValidatedNumerics.IntervalRounding

import Base: +, -, *, /, sqrt

function fast_two_sum{T<:AbstractFloat}(a::T, b::T)  # use only if exponent(a) >= exponent(b)
    #i.e. if abs(a) >= abs(b)
    s = a + b
    z = s - a
    t = b - z

    return (s, t)
end

function fast_two_sum_swap{T<:AbstractFloat}(a::T, b::T)  # only use if exponent(a) >= exponent(b)

    if abs(b) > abs(a)
        a, b = b, a
    end

    s = a + b
    z = s - a
    t = b - z

    return (s, t)
end


function two_sum{T<:AbstractFloat}(a::T, b::T)
    s  = a + b
    a′ = s - b
    b′ = s - a′
    δa = a - a′
    δb = b - b′
    t  = δa + δb

    return (s, t)
end

function fast2mult(a, b)
    π = a * b
    ρ = fma(a, b, -π)

    return (π, ρ)
end

function do_rounding(s, t, ::RoundingMode{:Up})
    t > 0 ? nextfloat(s) : s

    # version with no branch:
    # nextfloat(s, t > 0)
end

function do_rounding(s, t, ::RoundingMode{:Down})
    t < 0 ? prevfloat(s) : s

end


function +(::Type{IntervalRounding{:errorfree}}, a, b, r::RoundingMode)
    (s, t) = two_sum(a, b) # two_sum(a, b)
    do_rounding(s, t, r)

end

function -(::Type{IntervalRounding{:errorfree}}, a, b, r::RoundingMode)
    (s, t) = two_sum(a, -b)
    do_rounding(s, t, r)
end

function *(::Type{IntervalRounding{:errorfree}}, a, b, r::RoundingMode)
    (s, t) = fast2mult(a, b) # two_sum(a, b)
    do_rounding(s, t, r)
end

function /(::Type{IntervalRounding{:errorfree}}, a, b, ::RoundingMode{:Up})
    c = a / b
    d, e = fast2mult(c, b)

    # todo: separate according to sign of c
    if abs(d) > abs(a) || (d==a && e >= 0)  # the division is too big
        return c
    else
        return nextfloat(c)
    end
end

function /(::Type{IntervalRounding{:errorfree}}, a, b, ::RoundingMode{:Down})
    c = a / b
    d, e = fast2mult(c, b)

    if abs(d) < abs(a) || (abs(d) == abs(a) && e <= 0)  # the division is too big
        return c
    else
        return prevfloat(c)
    end
end

function sqrt(::Type{IntervalRounding{:errorfree}}, x, ::RoundingMode{:Up})
    y = sqrt(x)
    d, e = fast2mult(y, y)

    if abs(d) > abs(y) || (abs(d) == abs(y) && e > 0)  # the sqrt is too big
        return y
    else
        return nextfloat(y)
    end
end

function sqrt(::Type{IntervalRounding{:errorfree}}, x, ::RoundingMode{:Down})
    y = sqrt(x)
    d, e = fast2mult(y, y)

    if d < y || (d == y && e < 0)  # the sqrt is too big
        return y
    else
        return prevfloat(y)
    end
end

end
