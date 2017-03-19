
doc"""
    geometric_mid(X::Interval)

Find something like a geometric midpoint.
"""
function geometric_mid(X::Interval)

    m = sqrt(max(abs(X.lo), abs(X.hi)))

    if m ∉ X
        m = -m  # fix sign
    end

    return m
end

doc"""
    bisect(X::Interval, α=0.5)

Split the interval `X` at position α; α=0.5 corresponds to the midpoint.
If the interval has a large dynamic range, splits in a geometric, rather than arithmetic, way.

Returns a tuple of the new intervals.
"""
function bisect(X::Interval, α=0.5)
    @assert 0 ≤ α ≤ 1

    dynamic_range = abs(X.lo) / abs(X.hi)

    if isinf(X) || 1e-2 < dynamic_range < 1e2
        m = mid(X, α)  # use normal midpoint
    else
        m = geometric_mid(X)
    end

    return (Interval(X.lo, m), Interval(m, X.hi))
end

doc"""
    bisect(X::IntervalBox, α=0.5)

Bisect the `IntervalBox` `X` at position α ∈ [0,1] along its longest side.
"""
function bisect(X::IntervalBox, α=0.5)
    i = indmax(diam.(X))  # find longest side

    return bisect(X, i, α)
end

doc"""
    bisect(X::IntervalBox, i::Integer, α=0.5)

Bisect the `IntervalBox` in side number `i`.
"""
function bisect(X::IntervalBox, i::Integer, α=0.5)

    x1, x2 = bisect(X[i], α)

    X1 = setindex(X, x1, i)
    X2 = setindex(X, x2, i)

    return (X1, X2)
end
