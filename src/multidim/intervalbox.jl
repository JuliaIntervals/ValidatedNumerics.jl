# Multidimensional intervals, called IntervalBox


doc"""An `IntervalBox` is a Cartesian product of an arbitrary number of `Interval`s,
representing an $N$-dimensional rectangular IntervalBox."""

immutable IntervalBox{N, T} <: FixedVector{N, Interval{T}} # uses FixedSizeArrays package
    intervals :: NTuple{N, Interval{T}}
end

IntervalBox(x::Interval) = IntervalBox( (x,) )  # single interval treated as tuple with one element


mid(X::IntervalBox) = [mid(x) for x in X.intervals]

⊆(X::IntervalBox, Y::IntervalBox) = all([x ⊆ y for (x,y) in zip(X.intervals, Y.intervals)])

∩(X::IntervalBox, Y::IntervalBox) = IntervalBox([x ∩ y for (x,y) in zip(X.intervals, Y.intervals)]...)
isempty(X::IntervalBox) = any(map(isempty, X.intervals))

diam(X::IntervalBox) = maximum([diam(x) for x in X])


doc"""
    setdiff(x::IntervalBox, y::IntervalBox)

Calculate the set difference `X \ Y`, i.e. the set of values
that are inside the box `X` but not inside `Y`.
"""
function setdiff{N,T}(X::IntervalBox{N,T}, Y::IntervalBox{N,T})
    result = Interval{T}[]
    partial_overlaps = 0
    full_overlaps = 0
    partial_overlap_position = -1
    local partial_overlap

    which = 1
    for (x,y) in zip(X, Y)
        diff = setdiff(x, y)

        if diff == X # intersection is empty
            return X
        end

        if isempty(diff)
            full_overlaps += 1

        else
            partial_overlaps += 1
            partial_overlap_position = which
            partial_overlap = diff
        end

        which += 1

    end

    @show partial_overlaps, full_overlaps

    #IntervalBox( [setdiff(x,y) for (x,y) in zip(X, Y)]... )
    if partial_overlaps == 1
        return IntervalBox(X[1:which-1]..., diff, X[which+1...end]... )
    end


    if partial_overlaps > 1
        return X
    end


end

# doc"""
#     \(X::IntervalBox, Y::IntervalBox)
#
# Calculate the set difference of `X` and `Y`; alias for `setdiff(x, y)`.
# """
# \(X::IntervalBox, Y::IntervalBox) = setdiff(X, Y)


function show(io::IO, X::IntervalBox)
    for (i, x) in enumerate(X)
        print(io, x)
        if i != length(X)
            print(io, " × ")
        end
    end
end
