
using FactCheck
using ValidatedNumerics

facts("Interval tests") do
    a = Interval(@interval(1, 2), com)
    @fact decoration(a) --> com

    b = sqrt(a)
    @fact interval_part(b) --> sqrt(interval_part(a))
    @fact decoration(b) --> com

    a = Interval(@interval(-1, 1), com)
    b = sqrt(a)
    @fact interval_part(b) --> sqrt(BareInterval(0, 1))
    @fact decoration(b) --> trv

    d = Interval(a, dac)
    @fact decoration(d) --> dac

end
