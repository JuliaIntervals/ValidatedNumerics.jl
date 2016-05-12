using ValidatedNumerics
using FactCheck

facts("Tests with rational intervals") do

    a = BareInterval(1//2, 3//4)
    b = BareInterval(3//7, 9//12)

    @fact a + b --> BareInterval(13//14, 3//2)  # exact

    @fact sqrt(a + b) --> BareInterval(0.9636241116594314, 1.2247448713915892)

    X = BareInterval(1//3)
    @fact sqrt(X) --> BareInterval(0.5773502691896257, 0.5773502691896258)

end

setprecision(BareInterval, 64)

facts("Rounding rational intervals") do

    X = BareInterval(big(1)//3)
    Y = BareInterval(big"5.77350269189625764452e-01", big"5.77350269189625764561e-01")
    @fact sqrt(X) --> Y
end

facts("Tests with float intervals") do

    c = @floatinterval(0.1, 0.2)

    @fact isa(@floatinterval(0.1), BareInterval) --> true
    @fact c --> BareInterval(0.09999999999999999, 0.2)

    @fact widen(c) --> BareInterval(0.09999999999999998, 0.20000000000000004)

    @fact @floatinterval(pi) --> BareInterval(3.141592653589793, 3.1415926535897936)
end

facts("Testing functions of intervals") do
    f(x) = x + 0.1

    c = @floatinterval(0.1, 0.2)
    @pending f(c) --> BareInterval(0.19999999999999998, 0.30000000000000004)

    d = @interval(0.1, 0.2)
    @pending f(d) --> BareInterval(1.9999999999999998e-01, 3.0000000000000004e-01)
end

facts("Testing conversions") do
    f = @interval(0.1, 0.2)
    @pending @floatinterval(f) --> BareInterval(0.09999999999999999, 0.2)

    g = @floatinterval(0.1, 0.2)
    @pending @interval(g) --> BareInterval(9.9999999999999992e-02, 2.0000000000000001e-01)
end
