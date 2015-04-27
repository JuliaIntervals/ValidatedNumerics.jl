workspace()
using ValidatedNumerics


function extended_inverse{T}(X::Interval{T})
    #@show X
    if zero(T) ∉ X
        return [inv(X)]
    end

    return [-inv(Interval(zero(T), -X.lo)),
            inv(Interval(zero(T), X.hi))]

end

extended_inverse(@interval(1))
extended_inverse(@floatinterval(-1,1))
extended_inverse(@floatinterval(-1/3,1/3))


function N{T}(f, X::Interval{T})

    if isempty(X)
        return Interval{T}[]
    end

    f_prime = (D(f))(X)
    #inverse_list = extended_inverse(f_prime)  # one or two intervals

    M = Interval(mid(X))

    #results = Interval{T}[]

    Interval{T}[( (M - f(M)*inverse) ∩ X) for inverse in extended_inverse(f_prime)]
end

N{T}(f, XX::Vector{Interval{T}}) = vcat([N(f, X) for X in XX]...)


function do_newton(f, II)
    y = N(f, II)

    for i in 1:30

        y_new = N(f, y)

        if y_new == y
            break
        end

        y = y_new

    end

    sort(y)
end

f(x) = (x+1) * (x-2)
II = @floatinterval(-2, 3)

do_newton(f, II)



g(x) = (x-1) * (x-2)^2 + 1
II = @floatinterval(-5, 5)

do_newton(g, II)


h(x) = x*sin(1/x)
II = @floatinterval(0.01, 1)

do_newton(h, II)


h2(x) = (x-1)*(x-2)^2
II = @floatinterval(-5, 5)

do_newton(h2, II)


f20(x) = (x-1)*(x-2)*(x-3)*(x-4)*(x-5)*
    (x-6)*(x-7)*(x-8)*(x-9)*(x-10)*(x-11)*(x-12)*(x-13)*(x-14)*(x-15)*(x-16)*(x-17)*(x-18)*(x-19)*(x-20)

II = @floatinterval(-10000, 10000)
@time do_newton(f20, II)

with_bigfloat_precision(256) do
    II = @interval(-10000, 10000)
    @time sort(do_newton(f20, II))
end



using Polynomials


# function generate_wilkinson(n)
#     expr = :(x-1)
#     for i in 2:n
#         expr = :($expr * (x-$i))
#     end
#     @eval f(x) = $expr

#     return f
# end

# Defines functions e.g. f3 and f3_prime
# Should use Horner!
function generate_wilkinson(T, n)
    p = poly(collect(1:n))  # make polynomial with roots 1 to n
    p_prime = polyder(p)

    coeffs = [convert(T, coeff) for coeff in p.a]
    coeffs_prime = [convert(T, coeff) for coeff in p_prime.a]

    expr = :0
    for i in 1:length(coeffs)
        expr = :($expr + $(coeffs[i])*x^$(i-1))
    end

    fn = symbol("f$(n)")

    @eval $(fn)(x) = $expr

    @show expr

    expr = :0
    for i in 1:length(coeffs_prime)
        expr = :($expr + $(coeffs_prime[i])*x^$(i-1))
    end

    fn_prime = symbol("f$(n)_prime")
    @eval $(fn_prime)(x) = $expr

    @show expr

#     f(x) = sum( [coeffs[i]*x^(i-1) for i in 1:length(coeffs)] )
#     f_prime(x) = sum( [coeffs_prime[i]*x^(i-1) for i in 1:length(coeffs_prime)] )

    #return f, f_prime
end

generate_wilkinson(Float64, 3)

@assert f3(1) == f3(2) == f3(3) == 0
@assert f3_prime(4) == 11

II = @floatinterval(-5, 5)
@time do_newton(f3, II)

N(f3, II)

generate_wilkinson(Float64, 8)

II = @floatinterval(-100, 100)
@time do_newton(f8, II)

generate_wilkinson(Float64, 10)

II = @floatinterval(-100, 100)
@time do_newton(f10, II)


logistic(r, x) = r*x*(1-x)

function iterated_logistic(n, r, x)
    for i in 1:n
        x = logistic(r, x)
    end
    x
end

r = 3.1

II = @floatinterval(0, 1)

do_newton(x->logistic(r,x)-x, II)


do_newton(x->iterated_logistic(2, r,x)-x, II)

do_newton(x->iterated_logistic(4, 3.5,x)-x, II)

do_newton(x->iterated_logistic(8, 3.55,x)-x, II)

logistic


set_bigfloat_precision(53)
II = @interval(0, 1)

logistic(r, II)-II

I2 = do_newton(x->logistic(r,x)-x, II)

diam(I2[2])

set_bigfloat_precision(256)

I3 = do_newton(x->logistic(r,x)-x, I2[2])

diam(I3[1])

do_newton(x->iterated_logistic(2, r,x)-x, II)

do_newton(x->iterated_logistic(4, 3.5,x)-x, II)

do_newton(x->iterated_logistic(8, 3.55,x)-x, II)
