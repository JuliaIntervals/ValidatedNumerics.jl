# This file is part of the ValidatedNumerics.jl package; MIT licensed


"""
    in(x, a)
    ∈(x, a)

Checks if the number `x` is a member of the interval `a`, treated as a set.
Corresponds to `isMember` in the ITF-1788 Standard.
"""
function in{T<:Real}(x::T, a::Interval)
    isinf(x) && return false
    a.lo <= x <= a.hi
end



"""
    issubset(a,b)
    ⊆(a,b)

Checks if all the points of the interval `a` are within the interval `b`.
"""
function ⊆(a::Interval, b::Interval)
    isempty(a) && return true
    b.lo ≤ a.lo && a.hi ≤ b.hi
end


# Interior
function interior(a::Interval, b::Interval)
    isempty(a) && return true
    islessprime(b.lo, a.lo) && islessprime(a.hi, b.hi)
end
const ⪽ = interior  # \subsetdot

# Disjoint:
function isdisjoint(a::Interval, b::Interval)
    (isempty(a) || isempty(b)) && return true
    islessprime(b.hi, a.lo) || islessprime(a.hi, b.lo)
end


# Intersection
"""
    intersect(a, b)
    ∩(a,b)

Returns the intersection of the intervals `a` and `b`, considered as
(extended) sets of real numbers. That is, the set that contains
the points common in `a` and `b`.
"""
function intersect{T}(a::Interval{T}, b::Interval{T})
    isdisjoint(a,b) && return emptyinterval(T)

    Interval(max(a.lo, b.lo), min(a.hi, b.hi))
end
# Specific promotion rule for intersect:
intersect{T,S}(a::Interval{T}, b::Interval{S}) = intersect(promote(a,b)...)


## Hull
"""
    hull(a, b)

Returns the "convex hull" of the intervals `a` and `b`, considered as
(extended) sets of real numbers. That is, the minimum set that contains
all points in `a` and `b`.
"""
hull{T}(a::Interval{T}, b::Interval{T}) = Interval(min(a.lo, b.lo), max(a.hi, b.hi))

"""
    union(a, b)
    ∪(a,b)

Returns the union (convex hull) of the intervals `a` and `b`; it is equivalent
to `hull(a,b)`.
"""
union(a::Interval, b::Interval) = hull(a, b)




doc"""
    setdiff(x::Interval, y::Interval)

Calculate the set difference `x \ y`, i.e. the set of values
that are inside the interval `x` but not inside `y`.
"""
function setdiff(x::Interval, y::Interval)
    intersection = x ∩ y

    isempty(intersection) && return x
    intersection == x && return emptyinterval(x)

    x.lo == intersection.lo && return Interval(intersection.hi, x.hi)
    x.hi == intersection.hi && return Interval(x.lo, intersection.lo)

    return x   # intersection is inside x; the hull of the setdiff is the whole interval

end



doc"""
    \(x::Interval, y::Interval)

Calculate the set difference of `x` and `y`; an alias for `setdiff(x, y)`.
"""
\(x::Interval, y::Interval) = setdiff(x, y)
