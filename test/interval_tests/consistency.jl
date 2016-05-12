# This file is part of the ValidatedNumerics.jl package; MIT licensed

using ValidatedNumerics
using FactCheck

setprecision(BareInterval, Float64)

a = @interval(1.1, 0.1)
b = @interval(0.9, 2.0)
c = @interval(0.25, 4.0)

facts("Consistency tests") do

    @fact isa( @interval(1,2), BareInterval ) --> true
    @fact isa( @interval(0.1), BareInterval ) --> true
    @fact isa( zero(b), BareInterval ) --> true

    @fact zero(b) --> 0.0
    @fact zero(b) == zero(typeof(b)) --> true
    @fact one(a) --> 1.0
    @fact one(a) == one(typeof(a)) --> true
    @fact one(a) --> big(1.0)
    @fact a == b --> false
    @fact a != b --> true

    @fact a --> BareInterval(a.lo, a.hi)
    @fact @interval(1, Inf) --> BareInterval(1.0, Inf)
    @fact @interval(-Inf, 1) --> BareInterval(-Inf, 1.0)
    @fact @biginterval(1, Inf) --> BareInterval{BigFloat}(1.0, Inf)
    @fact @biginterval(-Inf, 1) --> BareInterval{BigFloat}(-Inf, 1.0)
    @fact @interval(-Inf, Inf) --> entireinterval(Float64)
    @fact emptyinterval(Rational{Int}) --> ∅

    @fact 1 == zero(a)+one(b) --> true
    @fact BareInterval(0,1) + emptyinterval(a) --> emptyinterval(a)
    @fact @interval(0.25) - one(c)/4 --> zero(c)
    @fact emptyinterval(a) - BareInterval(0,1) --> emptyinterval(a)
    @fact BareInterval(0,1) - emptyinterval(a) --> emptyinterval(a)
    @fact a*b --> BareInterval(a.lo*b.lo, a.hi*b.hi)
    @fact BareInterval(0,1) * emptyinterval(a) --> emptyinterval(a)
    @fact a * BareInterval(0) --> zero(a)
end

facts("inv") do

    @fact inv( zero(a) ) --> emptyinterval()
    @fact inv( @interval(0, 1) ) --> BareInterval(1, Inf)
    @fact inv( @interval(1, Inf) ) --> BareInterval(0, 1)
    @fact inv(c) --> c
    @fact one(b)/b --> inv(b)
    @fact a/emptyinterval(a) --> emptyinterval(a)
    @fact emptyinterval(a)/a --> emptyinterval(a)
    @fact inv(@interval(-4.0,0.0)) --> @interval(-Inf, -0.25)
    @fact inv(@interval(0.0,4.0)) --> @interval(0.25, Inf)
    @fact inv(@interval(-4.0,4.0)) --> entireinterval(Float64)
    @fact @interval(0)/@interval(0) --> emptyinterval()
    @fact typeof(emptyinterval()) --> BareInterval{Float64}
end

facts("fma consistency") do
    @fact fma(emptyinterval(), a, b) --> emptyinterval()
    @fact fma(entireinterval(), zero(a), b) --> b
    @fact fma(entireinterval(), one(a), b) --> entireinterval()
    @fact fma(zero(a), entireinterval(), b) --> b
    @fact fma(one(a), entireinterval(), b) --> entireinterval()
    @fact fma(a, zero(a), c) --> c
    @fact fma(BareInterval(1//2), BareInterval(1//3), BareInterval(1//12)) --> BareInterval(3//12)
end

facts("∈ tests") do
    @fact Inf ∈ entireinterval() --> false
    @fact 0.1 ∈ @interval(0.1) --> true
    @fact 0.1 in @interval(0.1) --> true
    @fact -Inf ∈ entireinterval() --> false
    @fact Inf ∈ entireinterval() --> false
end

facts("Inclusion tests") do
    @fact b ⊆ c --> true
    @fact emptyinterval(c) ⊆ c --> true
    @fact c ⊆ emptyinterval(c) --> false
    @fact interior(b,c) --> true
    @fact b ⪽ emptyinterval(b) --> false
    @fact emptyinterval(c) ⪽ c --> true
    @fact emptyinterval(c) ⪽ emptyinterval(c) --> true
    @fact isdisjoint(a, @interval(2.1)) --> true
    @fact isdisjoint(a, b) --> false
    @fact isdisjoint(emptyinterval(a), a) --> true
    @fact isdisjoint(emptyinterval(), emptyinterval()) --> true

end

facts("Comparison tests") do
    @fact ValidatedNumerics.islessprime(a.lo, b.lo) --> a.lo < b.lo
    @fact ValidatedNumerics.islessprime(Inf, Inf) --> true
    @fact ∅ <= ∅ --> true
    @fact BareInterval(1.0,2.0) <= ∅ --> false
    @fact BareInterval(-Inf,Inf) <= BareInterval(-Inf,Inf) --> true
    @fact BareInterval(-0.0,2.0) ≤ BareInterval(-Inf,Inf) --> false
    @fact precedes(∅,∅) --> true
    @fact precedes(BareInterval(3.0,4.0),∅) --> true
    @fact precedes(BareInterval(0.0,2.0),BareInterval(-Inf,Inf)) --> false
    @fact precedes(BareInterval(1.0,3.0),BareInterval(3.0,4.0)) --> true
    @fact strictprecedes(BareInterval(3.0,4.0),∅) --> true
    @fact strictprecedes(BareInterval(-3.0,-1.0),BareInterval(-1.0,0.0)) --> false
    @fact iscommon(emptyinterval()) --> false
    @fact iscommon(entireinterval()) --> false
    @fact iscommon(a) --> true
    @fact isunbounded(emptyinterval()) --> false
    @fact isunbounded(entireinterval()) --> true
    @fact isunbounded(BareInterval(-Inf, 0.0)) --> true
    @fact isunbounded(BareInterval(0.0, Inf)) --> true
    @fact isunbounded(a) --> false
end

facts("Intersection tests") do
    @fact emptyinterval() --> BareInterval(Inf, -Inf)
    @fact a ∩ @interval(-1) --> emptyinterval(a)
    @fact isempty(a ∩ @interval(-1) ) --> true
    @fact isempty(a) --> false
    @fact emptyinterval(a) == a --> false
    @fact emptyinterval() == emptyinterval() --> true

    @fact intersect(a, hull(a,b)) --> a
    @fact union(a,b) --> BareInterval(a.lo, b.hi)
end

facts("Special interval tests") do

    @fact entireinterval(Float64) --> BareInterval(-Inf, Inf)
    @fact isentire(entireinterval(a)) --> true
    @fact isentire(BareInterval(-Inf, Inf)) --> true
    @fact isentire(a) --> false
    @fact BareInterval(-Inf, Inf) ⪽ BareInterval(-Inf, Inf) --> true

    @fact nai(a) == nai(a) --> false
    @fact nai(a) === nai(a) --> true
    @fact nai(Float64) === BareInterval(NaN) --> true
    @fact isnan(nai(BigFloat).lo) --> true
    @fact isnai(nai()) --> true
    @fact isnai(a) --> false

    @fact infimum(a) == a.lo --> true
    @fact supremum(a) == a.hi --> true
    @fact infimum(emptyinterval(a)) --> Inf
    @fact supremum(emptyinterval(a)) --> -Inf
    @fact infimum(entireinterval(a)) --> -Inf
    @fact supremum(entireinterval(a)) --> Inf
    @fact isnan(supremum(nai(BigFloat))) --> true
end

facts("mid etc.") do

    @fact mid( BareInterval(1//2) ) --> 1//2
    @fact diam( BareInterval(1//2) ) --> 0//1
    @fact diam( @interval(1//10) ) --> eps(0.1)
    @fact diam( @interval(0.1) ) --> eps(0.1)
    @fact isnan(diam(emptyinterval())) --> true
    @fact mig(@interval(-2,2)) --> BigFloat(0.0)
    @fact mig( BareInterval(1//2) ) --> 1//2
    @fact isnan(mig(emptyinterval())) --> true
    @fact mag(-b) --> b.hi
    @fact mag( BareInterval(1//2) ) --> 1//2
    @fact isnan(mag(emptyinterval())) --> true
    @fact diam(a) --> 1.0000000000000002
end

facts("cancelplus tests") do

    x = BareInterval(-2.0, 4.440892098500622e-16)
    y = BareInterval(-4.440892098500624e-16, 2.0)
    @fact cancelminus(x, y) --> entireinterval(Float64)
    @fact cancelplus(x, y) --> entireinterval(Float64)
    x = BareInterval(-big(1.0), eps(big(1.0))/4)
    y = BareInterval(-eps(big(1.0))/2, big(1.0))
    @fact cancelminus(x, y) --> entireinterval(BigFloat)
    @fact cancelplus(x, y) --> entireinterval(BigFloat)
    x = BareInterval(-big(1.0), eps(big(1.0))/2)
    y = BareInterval(-eps(big(1.0))/2, big(1.0))
    @fact cancelminus(x, y) ⊆ BareInterval(-one(BigFloat), one(BigFloat)) --> true
    @fact cancelplus(x, y) --> BareInterval(zero(BigFloat), zero(BigFloat))
    @fact cancelminus(emptyinterval(), emptyinterval()) --> emptyinterval()
    @fact cancelplus(emptyinterval(), emptyinterval()) --> emptyinterval()
    @fact cancelminus(emptyinterval(), BareInterval(0.0, 5.0)) --> emptyinterval()
    @fact cancelplus(emptyinterval(), BareInterval(0.0, 5.0)) --> emptyinterval()
    @fact cancelminus(entireinterval(), BareInterval(0.0, 5.0)) --> entireinterval()
    @fact cancelplus(entireinterval(), BareInterval(0.0, 5.0)) --> entireinterval()
    @fact cancelminus(BareInterval(5.0), BareInterval(-Inf, 0.0)) --> entireinterval()
    @fact cancelplus(BareInterval(5.0), BareInterval(-Inf, 0.0)) --> entireinterval()
    @fact cancelminus(BareInterval(0.0, 5.0), emptyinterval()) --> entireinterval()
    @fact cancelplus(BareInterval(0.0, 5.0), emptyinterval()) --> entireinterval()
    @fact cancelminus(BareInterval(0.0), BareInterval(0.0, 1.0)) --> entireinterval()
    @fact cancelplus(BareInterval(0.0), BareInterval(0.0, 1.0)) --> entireinterval()
    @fact cancelminus(BareInterval(0.0), BareInterval(1.0)) --> BareInterval(-1.0)
    @fact cancelplus(BareInterval(0.0), BareInterval(1.0)) --> BareInterval(1.0)
    @fact cancelminus(BareInterval(-5.0, 0.0), BareInterval(0.0, 5.0)) --> BareInterval(-5.0)
    @fact cancelplus(BareInterval(-5.0, 0.0), BareInterval(0.0, 5.0)) --> BareInterval(0.0)
end

facts("mid and radius") do

    # NOTE: By some strange reason radius is not recognized here
    @fact ValidatedNumerics.radius(BareInterval(-1//10,1//10)) -->
        diam(BareInterval(-1//10,1//10))/2
    @fact isnan(ValidatedNumerics.radius(emptyinterval())) --> true
    @fact mid(c) == 2.125 --> true
    @fact isnan(mid(emptyinterval())) --> true
    @fact mid(entireinterval()) == 0.0 --> true
    @fact isnan(mid(nai())) --> true
    # In v0.3 it corresponds to AssertionError
    @fact_throws ArgumentError nai(BareInterval(1//2))
end

facts("abs, min, max, sign") do

    @fact abs(entireinterval()) --> BareInterval(0.0, Inf)
    @fact abs(emptyinterval()) --> emptyinterval()
    @fact abs(BareInterval(-3.0,1.0)) --> BareInterval(0.0, 3.0)
    @fact abs(BareInterval(-3.0,-1.0)) --> BareInterval(1.0, 3.0)
    @fact min(entireinterval(), BareInterval(3.0,4.0)) --> BareInterval(-Inf, 4.0)
    @fact min(emptyinterval(), BareInterval(3.0,4.0)) --> emptyinterval()
    @fact min(BareInterval(-3.0,1.0), BareInterval(3.0,4.0)) --> BareInterval(-3.0, 1.0)
    @fact min(BareInterval(-3.0,-1.0), BareInterval(3.0,4.0)) --> BareInterval(-3.0, -1.0)
    @fact max(entireinterval(), BareInterval(3.0,4.0)) --> BareInterval(3.0, Inf)
    @fact max(emptyinterval(), BareInterval(3.0,4.0)) --> emptyinterval()
    @fact max(BareInterval(-3.0,1.0), BareInterval(3.0,4.0)) --> BareInterval(3.0, 4.0)
    @fact max(BareInterval(-3.0,-1.0), BareInterval(3.0,4.0)) --> BareInterval(3.0, 4.0)
    @fact sign(entireinterval()) --> BareInterval(-1.0, 1.0)
    @fact sign(emptyinterval()) --> emptyinterval()
    @fact sign(BareInterval(-3.0,1.0)) --> BareInterval(-1.0, 1.0)
    @fact sign(BareInterval(-3.0,-1.0)) --> BareInterval(-1.0, -1.0)

    @fact log(@interval(-2,5)) --> @interval(-Inf,log(5.0))

    # Test putting functions in @interval:
    @fact @interval(sin(0.1) + cos(0.2)) --> sin(@interval(0.1)) + cos(@interval(0.2))

    f(x) = 2x
    @fact @interval(f(0.1)) --> f(@interval(0.1))

    # midpoint-radius representation
    a = @interval(0.1)
    midpoint, radius = midpoint_radius(a)

    @fact interval_from_midpoint_radius(midpoint, radius) -->
        BareInterval(0.09999999999999999, 0.10000000000000002)

end

facts("Precision tests") do
    setprecision(BareInterval, 100)
    @fact precision(BareInterval) == (BigFloat, 100) --> true

    setprecision(BareInterval, Float64)
    @fact precision(BareInterval) == (Float64, 100) --> true

    a = @interval(0.1, 0.3)

    b = setprecision(BareInterval, 64) do
        @interval(0.1, 0.3)
    end

    @fact b ⊆ a --> true

    @fact precision(BareInterval) == (Float64, 100) --> true

end

facts("BareInterval rounding tests") do
    setrounding(BareInterval, :wide)
    @fact rounding(BareInterval) == :wide --> true

    @fact_throws ArgumentError setrounding(BareInterval, :hello)

    setrounding(BareInterval, :narrow)
    @fact rounding(BareInterval) == :narrow --> true

end

facts("BareInterval power of an interval") do
    a = @interval(1, 2)
    b = @interval(3, 4)

    @fact a^b --> @interval(1, 16)
    @fact a^@interval(0.5, 1) --> a
    @fact a^@interval(0.3, 0.5) --> @interval(1, sqrt(2))

    @fact b^@interval(0.3) == BareInterval(1.3903891703159093, 1.5157165665103982) --> true

end

facts("Rational infinity") do
    @fact inf(3//4) == 1//0 --> true
end
