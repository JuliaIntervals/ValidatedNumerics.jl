# Multidimensional intervals, called IntervalBox


doc"""An `IntervalBox` is a Cartesian product of an arbitrary number of `BareInterval`s,
representing an $N$-dimensional rectangular IntervalBox."""

immutable IntervalBox{N, T} <: FixedVector{N, BareInterval{T}} # uses FixedSizeArrays package
    intervals :: NTuple{N, BareInterval{T}}
end

IntervalBox(x::BareInterval) = IntervalBox( (x,) )  # single interval treated as tuple with one element


mid(X::IntervalBox) = [mid(x) for x in X.intervals]

⊆(X::IntervalBox, Y::IntervalBox) = all([x ⊆ y for (x,y) in zip(X.intervals, Y.intervals)])

∩(X::IntervalBox, Y::IntervalBox) = IntervalBox([x ∩ y for (x,y) in zip(X.intervals, Y.intervals)]...)
isempty(X::IntervalBox) = any(map(isempty, X.intervals))


function show(io::IO, X::IntervalBox)
    for (i, x) in enumerate(X)
        print(io, x)
        if i != length(X)
            print(io, " × ")
        end
    end
end
