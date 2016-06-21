using ValidatedNumerics
using FactCheck

const D = ValidatedNumerics.derivative

include("wilkinson.jl")


function generate_wilkinson(n)#, T=BigFloat)   # SLOW

    p = poly(collect(1:n))
    p_prime = polyder(p)

    coeffs = p.a #[convert(T, coeff) for coeff in p.a]
    # coeffs_prime = [convert(T, coeff) for coeff in p_prime.a]

    function f(x)
        total = coeffs[1]
        for i in 2:length(coeffs)
            total += coeffs[i]*x^(i-1)
        end
        total
    end

    f
end


setprecision(Interval, Float64)
float_pi = @interval(pi)

setprecision(Interval, 10000)
big_pi = @interval(pi)
# Using precision "only" 256 leads to overestimation of the true roots for `cos`
# i.e the Newton method gives more accurate results!

half_pi = big_pi / 2
three_halves_pi = 3*big_pi/2


# Format:  (function, derivative, lower_bound, upper_bound, [true_roots])
function_list = [
                    (sin, cos,    -5,  5,    [ -big_pi, @interval(0), big_pi ] ) ,
                    (cos, x->D(cos, x), -7.5, 7.5, [ -three_halves_pi, -half_pi, half_pi, three_halves_pi ] ),
                    (W₃, x->D(W₃, x),   -10, 10,   [ @interval(1), @interval(2), @interval(3) ] ),
                    (W₇, x->D(W₇, x),   -10, 10,   [ @interval(i) for i in 1:7 ] ),
                    (x->exp(x)-2, y->D(x->exp(x),y),  -20, 20,  [log(@biginterval(2))] ),
                    (x->asin(sin(x)) - 0.1, y->D(x->asin(sin(x)),y), 0, 1, [@biginterval(0.1)])
                ]


facts("Testing root finding") do

    for rounding_type in (:wide, :narrow)
        context("Interval rounding: $rounding_type") do
            setrounding(Interval, rounding_type)

            for prec in ( (BigFloat,53), (BigFloat,256), (Float64,64) )
                context("Precision: $prec") do
                    setprecision(Interval, prec)

                    for method in (newton, krawczyk)
                        context("Method $method") do

                            for func in function_list

                                f, f_prime, a_lower, a_upper, true_roots = func
                                a = @interval(a_lower, a_upper)

                                context("Function $f; interval $a") do

                                    for autodiff in (false, true)

                                        context("With autodiff=$autodiff") do

                                            if autodiff
                                                roots = method(f, a)
                                            else
                                                roots = method(f, f_prime, a)
                                            end

                                            @fact length(roots) --> length(true_roots)

                                            for i in 1:length(roots)
                                                root = roots[i]

                                                @fact isa(root, Root{prec[1]}) --> true
                                                @fact is_unique(root) --> true
                                                @fact true_roots[i] ⊆ root.interval --> true
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end



f(x) = x^2 - 2

roots = newton(f, @interval(10, 11))

facts() do
    @fact length(roots) --> 0
end

setprecision(Interval, Float64)

facts("find_roots tests") do
    f(x) = x^2 - 2


    roots = find_roots_midpoint(f, -5, 5)
    @fact length(roots) --> 3
    @fact length(roots[1]) --> 2

    roots = find_roots(f, -5, 5)
    @fact length(roots) --> 2

    setprecision(Interval, 256)

    for method in (newton, krawczyk)
        new_roots = method(f, roots)
        @fact length(new_roots) == length(roots) --> true

        for (root1, root2) in zip(new_roots, roots)
            @fact root1 ⊆ root2 --> true
        end
    end

end



# Example of a function with a double root at 0 from Burden & Faires, 9th ed, p.84
# exp(x) - x - 1
