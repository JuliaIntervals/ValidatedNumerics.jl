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

diam(X::IntervalBox) = maximum([diam(x) for x in X])


doc"""
    setdiff(x::IntervalBox, y::IntervalBox)

Calculate the set difference `X \ Y`, i.e. the set of values
that are inside the box `X` but not inside `Y`.
"""
# function setdiff{N,T}(X::IntervalBox{N,T}, Y::IntervalBox{N,T})
#     result = Interval{T}[]
#     partial_overlaps = 0
#     full_overlaps = 0
#     which = -1
#     local overlap
#     local d
#
#     #which = 1
#     #@show (X, Y)
#     for (i, (x,y)) in enumerate(zip(X, Y))
#
#         if isempty(x ∩ y)  # or d == x
#             return X
#         end
#
#         d = setdiff(x, y)
#         #@show d, typeof(d)
#
#         # if d == x # intersection is empty
#         #     return X
#         # end
#
#         if isempty(d)
#             full_overlaps += 1
#
#         else
#             partial_overlaps += 1
#
#             if partial_overlaps > 1  # there can only be one partial overlap
#                 # else the setdiff as an IntervalBox is the whole of the original IntervalBox
#                 warn("HELLO")
#                 @show X
#                 @show Y
#                 return X
#
#             end
#
#             which = i
#             overlap = d
#         end
#
#         #which += 1
#
#     end
#
#     #@show partial_overlaps, full_overlaps
#
#     #IntervalBox( [setdiff(x,y) for (x,y) in zip(X, Y)]... )
#     if partial_overlaps == 1
#         return IntervalBox(X[1:which-1]..., overlap, X[which+1:end]...)
#     end
#
#     @assert full_overlaps == length(X)
#
#     # all full overlaps
#
#     return IntervalBox([emptyinterval() for i in 1:length(X)]...)
#
#
# end

function setdiff{N,T}(X::IntervalBox{N,T}, Y::IntervalBox{N,T})
    IntervalBox([setdiff(x, y) for (x,y) in zip(X, Y)]...)

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
