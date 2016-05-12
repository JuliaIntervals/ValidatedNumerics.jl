# This file is part of the ValidatedNumerics.jl package; MIT licensed

using ValidatedNumerics
using FactCheck

setprecision(BareInterval, Float64)
setrounding(BareInterval, :narrow)


facts("Numeric tests") do

    a = @interval(1.1, 0.1)
    b = @interval(0.9, 2.0)
    c = @interval(0.25, 4.0)


    ## Basic arithmetic
    @fact @interval(0.1) --> BareInterval(9.9999999999999992e-02, 1.0000000000000001e-01)
    @fact +a == a --> true
    @fact a+b --> BareInterval(9.9999999999999989e-01, 3.1000000000000001e+00)
    @fact -a --> BareInterval(-1.1000000000000001e+00, -9.9999999999999992e-02)
    @fact a-b --> BareInterval(-1.9000000000000001e+00, 2.0000000000000018e-01)
    @fact BareInterval(1//4,1//2) + BareInterval(2//3) --> BareInterval(11//12, 7//6)
    @fact BareInterval(1//4,1//2) - BareInterval(2//3) --> BareInterval(-5//12, -1//6)

    @fact 10a --> @interval(10a)
    #@fact 10BareInterval(1//10) --> one(@interval(1//10))
    @fact BareInterval(-30.0,-15.0) / BareInterval(-5.0,-3.0) --> BareInterval(3.0, 10.0)
    @fact @interval(-30,-15) / @interval(-5,-3) --> BareInterval(3.0, 10.0)
    @fact b/a --> BareInterval(8.18181818181818e-01, 2.0000000000000004e+01)
    @fact a/c --> BareInterval(2.4999999999999998e-02, 4.4000000000000004e+00)
    @fact c/4.0 --> BareInterval(6.25e-02, 1e+00)
    @fact c/zero(c) --> emptyinterval(c)
    @fact BareInterval(0.0, 1.0)/BareInterval(0.0,1.0) --> BareInterval(0.0, Inf)
    @fact BareInterval(-1.0, 1.0)/BareInterval(0.0,1.0) --> entireinterval(c)
    @fact BareInterval(-1.0, 1.0)/BareInterval(-1.0,1.0) --> entireinterval(c)
end

facts("Power tests") do
    @fact @interval(0,3) ^ 2 --> BareInterval(0, 9)
    @fact @interval(2,3) ^ 2 --> BareInterval(4, 9)
    @fact @interval(-3,0) ^ 2 --> BareInterval(0, 9)
    @fact @interval(-3,-2) ^ 2 --> BareInterval(4, 9)
    @fact @interval(-3,2) ^ 2 --> BareInterval(0, 9)
    @fact @interval(0,3) ^ 3 --> BareInterval(0, 27)
    @fact @interval(2,3) ^ 3 --> BareInterval(8, 27)
    @fact @interval(-3,0) ^ 3 --> @interval(-27., 0.)
    @fact @interval(-3,-2) ^ 3 --> @interval(-27, -8)
    @fact @interval(-3,2) ^ 3 --> @interval(-27., 8.)
    @fact BareInterval(0,3) ^ -2 --> BareInterval(1/9, Inf)
    @fact BareInterval(-3,0) ^ -2 --> BareInterval(1/9, Inf)
    @fact BareInterval(-3,2) ^ -2 --> BareInterval(1/9, Inf)
    @fact BareInterval(2,3) ^ -2 --> BareInterval(1/9, 1/4)
    @fact BareInterval(1,2) ^ -3 --> BareInterval(1/8, 1.0)
    @fact BareInterval(0,3) ^ -3 --> @interval(1/27, Inf)
    @fact BareInterval(-1,2) ^ -3 --> entireinterval()
    @fact_throws ArgumentError BareInterval(-1, -2) ^ -3  # wrong way round
    @fact BareInterval(-3,2) ^ (3//1) --> BareInterval(-27, 8)
    @fact BareInterval(0.0) ^ 1.1 --> BareInterval(0, 0)
    @fact BareInterval(0.0) ^ 0.0 --> emptyinterval()
    @fact BareInterval(0.0) ^ (1//10) --> BareInterval(0, 0)
    @fact BareInterval(0.0) ^ (-1//10) --> emptyinterval()
    @fact ∅ ^ 0 --> ∅
    @fact BareInterval(2.5)^3 --> BareInterval(15.625, 15.625)
    #@fact BareInterval(5//2)^3.0 --> BareInterval(125//8)

    x = @interval(-3,2)
    @fact x^3 --> @interval(-27, 8)

    @fact @interval(-3,4) ^ 0.5 --> @interval(0, 2)
    @fact @interval(-3,4) ^ 0.5 --> @interval(-3,4)^(1//2)
    @fact @interval(-3,2) ^ @interval(2) --> BareInterval(0.0, 4.0)
    @fact @interval(-3,4) ^ @interval(0.5) --> BareInterval(0, 2)
    @fact @biginterval(-3,4) ^ 0.5 --> @biginterval(0, 2)

    @fact @interval(1,27)^@interval(1/3) --> roughly(BareInterval(1., 3.))
    @fact @interval(1,27)^(1/3) --> roughly(BareInterval(1., 3.))
    @fact BareInterval(1., 3.) ⊆ @interval(1,27)^(1//3) --> true
    @fact @interval(0.1,0.7)^(1//3) --> BareInterval(0.46415888336127786, 0.8879040017426008)
    @fact @interval(0.1,0.7)^(1/3)  --> roughly(BareInterval(0.46415888336127786, 0.8879040017426008))

    setprecision(BareInterval, 256)
    x = @biginterval(27)
    y = x^(1//3)
    @fact (0 < diam(y) < 1e-76) --> true
    y = x^(1/3)
    @fact (0 < diam(y) < 1e-76) --> true
    @fact x^(1//3) --> x^(1/3)
end

setprecision(BareInterval, Float64)

facts("Exp and log tests") do
    @fact exp(@biginterval(1//2)) ⊆ exp(@interval(1//2)) --> true
    @fact exp(@interval(1//2)) --> BareInterval(1.648721270700128, 1.6487212707001282)
    @fact exp(@biginterval(0.1)) ⊆ exp(@interval(0.1)) --> true
    @fact exp(@interval(0.1)) --> BareInterval(1.1051709180756475e+00, 1.1051709180756477e+00)
    @fact diam(exp(@interval(0.1))) --> eps(exp(0.1))

    @fact log(@biginterval(1//2)) ⊆ log(@interval(1//2)) --> true
    @fact log(@interval(1//2)) --> BareInterval(-6.931471805599454e-01, -6.9314718055994529e-01)
    @fact log(@biginterval(0.1)) ⊆ log(@interval(0.1)) --> true
    @fact log(@interval(0.1)) --> BareInterval(-2.3025850929940459e+00, -2.3025850929940455e+00)
    @fact diam(log(@interval(0.1))) --> eps(log(0.1))

    @fact exp2(@biginterval(1//2)) ⊆ exp2(@interval(1//2)) --> true
    @fact exp2(BareInterval(1024.0)) --> BareInterval(1.7976931348623157e308, Inf)
    @fact exp10(@biginterval(1//2)) ⊆ exp10(@interval(1//2)) --> true
    @fact exp10(BareInterval(308.5)) --> BareInterval(1.7976931348623157e308, Inf)

    @fact log2(@biginterval(1//2)) ⊆ log2(@interval(1//2)) --> true
    @fact log2(@interval(0.25, 0.5)) --> BareInterval(-2.0, -1.0)
    @fact log10(@biginterval(1//10)) ⊆ log10(@interval(1//10)) --> true
    @fact log10(@interval(0.01, 0.1)) --> @interval(log10(0.01), log10(0.1))
end

facts("Comparison tests") do
    d = @interval(0.1, 2)

    @fact d < 3 --> true
    @fact d <= 2 --> true
    @fact d < 2 --> false
    @fact -1 < d --> true
    @fact !(d < 0.15) --> true

    # abs
    @fact abs(@interval(0.1, 0.2)) --> BareInterval(9.9999999999999992e-02, 2.0000000000000001e-01)
    @fact abs(@interval(-1, 2)) --> BareInterval(0, 2)

    # real
    @fact real(@interval(-1, 1)) --> BareInterval(-1, 1)
end

facts("Rational tests") do

    f = 1 // 3
    g = 1 // 3

    @fact @interval(f*g) --> BareInterval(1.1111111111111109e-01, 1.1111111111111115e-01)
    @fact big(1.)/9 ∈ @interval(f*g) --> true
    @fact @interval(1)/9 ⊆ @interval(f*g) --> true
    @fact @interval(1)/9 ≠ @interval(f*g) --> true

    h = 1/3
    i = 1/3

    @fact @interval(h*i) --> BareInterval(1.1111111111111109e-01, 1.1111111111111115e-01)
    @fact big(1.)/9 ∈ @interval(1/9) --> true

    @fact @interval(1/9) == @interval(1//9) --> true
end

facts("Floor etc. tests") do
    a = @interval(0.1)
    b = BareInterval(0.1, 0.1)
    @fact dist(a,b) <= eps(a) --> true

    @fact floor(@interval(0.1, 1.1)) --> BareInterval(0, 1)
    @fact round(@interval(0.1, 1.1), RoundDown) --> BareInterval(0, 1)
    @fact ceil(@interval(0.1, 1.1)) --> BareInterval(1, 2)
    @fact round(@interval(0.1, 1.1), RoundUp) --> BareInterval(1, 2)
    @fact sign(@interval(0.1, 1.1)) --> BareInterval(1.0)
    @fact trunc(@interval(0.1, 1.1)) --> BareInterval(0.0, 1.0)
    @fact round(@interval(0.1, 1.1), RoundToZero) --> BareInterval(0.0, 1.0)
    @fact round(@interval(0.1, 1.1)) --> BareInterval(0.0, 1.0)
    @fact round(@interval(0.1, 1.5)) --> BareInterval(0.0, 2.0)
    @fact round(@interval(-1.5, 0.1)) --> BareInterval(-2.0, 0.0)
    @fact round(@interval(-2.5, 0.1)) --> BareInterval(-2.0, 0.0)
    @fact round(@interval(0.1, 1.1), RoundTiesToEven) --> BareInterval(0.0, 1.0)
    @fact round(@interval(0.1, 1.5), RoundTiesToEven) --> BareInterval(0.0, 2.0)
    @fact round(@interval(-1.5, 0.1), RoundTiesToEven) --> BareInterval(-2.0, 0.0)
    @fact round(@interval(-2.5, 0.1), RoundTiesToEven) --> BareInterval(-2.0, 0.0)
    @fact round(@interval(0.1, 1.1), RoundTiesToAway) --> BareInterval(0.0, 1.0)
    @fact round(@interval(0.1, 1.5), RoundTiesToAway) --> BareInterval(0.0, 2.0)
    @fact round(@interval(-1.5, 0.1), RoundTiesToAway) --> BareInterval(-2.0, 0.0)
    @fact round(@interval(-2.5, 0.1), RoundTiesToAway) --> BareInterval(-3.0, 0.0)

    # :wide tests
    setrounding(BareInterval, :wide)
    setprecision(BareInterval, Float64)

    a = @interval(-3.0, 2.0)
    @fact a --> BareInterval(-3.0, 2.0)
    @fact a^3 --> BareInterval(-27.000000000000004, 8.000000000000002)
    @fact BareInterval(-3,2)^3 --> BareInterval(-27.000000000000004, 8.000000000000002)

    @fact BareInterval(-27.0, 8.0)^(1//3) --> BareInterval(-5.0e-324, 2.0000000000000004)

    setrounding(BareInterval, :narrow)
end
