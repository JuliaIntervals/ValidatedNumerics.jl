# This file is part of the ValidatedNumerics.jl package; MIT licensed

using ValidatedNumerics
using FactCheck

facts("setdiff") do
    x = 2..4
    y = 3..5

    @fact x \ y --> 2..3
    @fact setdiff(x, y) --> 2..3

    X = IntervalBox(2..4, 3..5)
    Y = IntervalBox(3..5, 4..6)

    x = 2..4
    y = 2..5
    @fact y \ x --> 4..5

    @fact X \ Y --> IntervalBox(2..3, 3..4)
    @fact setdiff(X, Y) --> IntervalBox(2..3, 3..4)
end
