
using FactCheck
using ValidatedNumerics

facts("DecoratedInterval tests") do
    a = DecoratedInterval(@interval(1, 2), com)
    @fact decoration(a) --> com

    b = sqrt(a)
    @fact interval_part(b) --> sqrt(interval_part(a))
    @fact decoration(b) --> com

    a = DecoratedInterval(@interval(-1, 1), com)
    b = sqrt(a)
    @fact interval_part(b) --> sqrt(Interval(0, 1))
    @fact decoration(b) --> trv

    d = DecoratedInterval(a, dac)
    @fact decoration(d) --> dac

end
