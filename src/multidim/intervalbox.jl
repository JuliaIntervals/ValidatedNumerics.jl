# This file is part of the ValidatedNumerics.jl package; MIT licensed

doc"""An `IntervalBox` is an $N$-dimensional rectangular box, given
by a Cartesian product of $N$ `Interval`s.
"""

immutable IntervalBox{N, T} <: FixedVector{N, Interval{T}}  # uses FixedSizeArrays.jl package
    _ :: NTuple{N, Interval{T}}
end

IntervalBox(x::Interval) = IntervalBox( (x,) )  # single interval treated as tuple with one element


## arithmetic operations
# Note that standard arithmetic operations are implemented automatically by FixedSizeArrays.jl

mid(X::IntervalBox) = [mid(x) for x in X]


## set operations

# TODO: Update to use generator
⊆(X::IntervalBox, Y::IntervalBox) = all([x ⊆ y for (x,y) in zip(X, Y)])

∩{N,T}(X::IntervalBox{N,T}, Y::IntervalBox{N,T}) = IntervalBox(ntuple(i -> X[i] ∩ Y[i], Val{N}))
∪{N,T}(X::IntervalBox{N,T}, Y::IntervalBox{N,T}) = IntervalBox(ntuple(i -> X[i] ∪ Y[i], Val{N}))

∪{T}(a::Interval{T}, b::Interval{T}) = hull(a, b)


isempty(X::IntervalBox) = any(isempty, X)

diam(X::IntervalBox) = maximum([diam(x) for x in X])

emptyinterval(X::IntervalBox) = IntervalBox(map(emptyinterval, X))


import Base.×
×(a::Interval...) = IntervalBox(a...)
×(a::Interval, b::IntervalBox) = IntervalBox(a, b...)
×(a::IntervalBox, b::Interval) = IntervalBox(a..., b)
×(a::IntervalBox, b::IntervalBox) = IntervalBox(a..., b...)
