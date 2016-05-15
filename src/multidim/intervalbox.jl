# Multidimensional intervals, called IntervalBox


doc"""An `IntervalBox` is a Cartesian product of an arbitrary number of `Interval`s,
representing an $N$-dimensional rectangular IntervalBox."""

immutable IntervalBox{N, T} <: FixedVector{N, Interval{T}} # uses FixedSizeArrays package
    _ :: NTuple{N, Interval{T}}
end

IntervalBox(x::Interval) = IntervalBox( (x,) )  # single interval treated as tuple with one element


mid(X::IntervalBox) = [mid(x) for x in X]

⊆(X::IntervalBox, Y::IntervalBox) = all([x ⊆ y for (x,y) in zip(X, Y)])

∩(X::IntervalBox, Y::IntervalBox) = IntervalBox([x ∩ y for (x,y) in zip(X, Y)]...)
isempty(X::IntervalBox) = any([isempty(x) for x in X])

doc"""
    setdiff(x::IntervalBox, y::IntervalBox)

Calculate the set difference `X \ Y`, i.e. the set of values
that are inside the box `X` but not inside `Y`.
"""
function setdiff(X::IntervalBox, Y::IntervalBox)
    IntervalBox( [setdiff(x,y) for (x,y) in zip(X, Y)]... )
end

doc"""
    \(X::IntervalBox, Y::IntervalBox)

Calculate the set difference of `X` and `Y`; alias for `setdiff(x, y)`.
"""
\(X::IntervalBox, Y::IntervalBox) = setdiff(X, Y)


function show(io::IO, X::IntervalBox)
    for (i, x) in enumerate(X)
        print(io, x)
        if i != length(X)
            print(io, " × ")
        end
    end
end
