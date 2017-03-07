# This file is part of the ValidatedNumerics.jl package; MIT licensed

doc"""An `IntervalBox` is an $N$-dimensional rectangular box, given
by a Cartesian product of $N$ `Interval`s.
"""


# typealias IntervalBox{N,T} SVector{N,Interval{T}}

immutable IntervalBox{N,T} <: StaticVector{N}
    data::NTuple{N,T}
end


(::Type{IntervalBox}){N,T}(x::NTuple{N, Interval{T}}) = SVector{N,Interval{T}}(x)

IntervalBox(x::Interval) = IntervalBox( (x,) )  # single interval treated as tuple with one element


## arithmetic operations
# Note that standard arithmetic operations are implemented automatically by FixedSizeArrays.jl

mid(X::IntervalBox) = [mid(x) for x in X]


## set operations

# TODO: Update to use generator
⊆{N,T}(X::IntervalBox{N,T}, Y::IntervalBox{N,T}) = all(i->(X[i] ⊆ Y[i]), 1:N)
# all(X[i] ⊆ Y[i] for i in 1:N)  # on Julia 0.6

∩{N,T}(X::IntervalBox{N,T}, Y::IntervalBox{N,T}) = IntervalBox(ntuple(i -> X[i] ∩ Y[i], Val{N}))
∪{N,T}(X::IntervalBox{N,T}, Y::IntervalBox{N,T}) = IntervalBox(ntuple(i -> X[i] ∪ Y[i], Val{N}))

#=
On Julia 0.6 can now write
∩{N,T}(X::IntervalBox{N,T}, Y::IntervalBox{N,T}) = IntervalBox(NTuple{N, Interval{Float64}}( (X[i] ∩ Y[i]) for i in 1:N))
=#


isempty(X::IntervalBox) = any(isempty, X)

# TODO: Replace with generator in 0.5:
diam(X::IntervalBox) = maximum([diam(x) for x in X])

emptyinterval{N,T}(X::IntervalBox{N,T}) = IntervalBox(ntuple(i->emptyinterval(T), Val{N}))


import Base.×
×(a::Interval...) = IntervalBox(a...)
×(a::Interval, b::IntervalBox) = IntervalBox(a, b...)
×(a::IntervalBox, b::Interval) = IntervalBox(a..., b)
×(a::IntervalBox, b::IntervalBox) = IntervalBox(a..., b...)
