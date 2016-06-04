# This file is part of the ValidatedNumerics.jl package; MIT licensed

doc"""An `IntervalBox` is an $N$-dimensional rectangular box, given
by a Cartesian product of $N$ `Interval`s.
"""

immutable IntervalBox{N, T} <: FixedVector{N, Interval{T}}  # uses FixedSizeArrays.jl package
    _ :: NTuple{N, Interval{T}}
end

IntervalBox(x::Interval) = IntervalBox( (x,) )  # single interval treated as tuple with one element

## arithmetic operations

# standard arithmetic operations are implemented by FixedSizeArrays.jl

## arithmetic operations
# Note that standard arithmetic operations are implemented automatically by FixedSizeArrays.jl

mid(X::IntervalBox) = [mid(x) for x in X]


## set operations

⊆(X::IntervalBox, Y::IntervalBox) = all([x ⊆ y for (x,y) in zip(X, Y)])

∩(X::IntervalBox, Y::IntervalBox) = IntervalBox([x ∩ y for (x,y) in zip(X, Y)]...)

isempty(X::IntervalBox) = any(isempty, X)

diam(X::IntervalBox) = maximum([diam(x) for x in X])

<<<<<<< 86fd9400d143f051860cbe7e9b054e45e73a76e1
<<<<<<< 005b38c0425c4ffebae1850d7627a7f154d71adc
=======
>>>>>>> Rewrite a couple of IntervalBox functions; better structure for intervalbox.jl
emptyinterval(X::IntervalBox) = IntervalBox(map(emptyinterval, X))


## printing
<<<<<<< 86fd9400d143f051860cbe7e9b054e45e73a76e1
=======
emptyinterval(x::IntervalBox) = IntervalBox([emptyinterval(i) for i in x]...)
>>>>>>> Add emptyinterval(x::IntervalBox)
=======
>>>>>>> Rewrite a couple of IntervalBox functions; better structure for intervalbox.jl

function show(io::IO, X::IntervalBox)
    for (i, x) in enumerate(X)
        print(io, x)
        if i != length(X)
            print(io, " × ")
        end
    end
end
