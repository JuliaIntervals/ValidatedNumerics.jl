
using FactCheck
using ValidatedNumerics

facts("Decorated tests") do
    a = Decorated(@interval(1, 2), com)
    @fact decoration(a) --> com

    b = sqrt(a)
    @fact interval_part(b) --> sqrt(interval_part(a))
    @fact decoration(b) --> com

    a = Decorated(@interval(-1, 1), com)
    b = sqrt(a)
    @fact interval_part(b) --> sqrt(Interval(0, 1))
    @fact decoration(b) --> trv

    d = Decorated(a, dac)
    @fact decoration(d) --> dac

end
