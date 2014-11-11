# Newton method

function guarded_mid(x::Interval)
    m = mid(x)
    if m == zero(x.lo)  # midpoint exactly 0
        alpha = 0.45
        m = alpha*x.lo + (1.0-alpha)*x.hi   # displace to another point in the interval
    end

    m
end

function N(f::Function, x::Interval, deriv::Interval)
    m = guarded_mid(x)
    m = Interval(m)
    Nx = m - f(m) * inv(deriv)
    Nx
end

function newton_refine(f::Function, f_prime::Function, x::Interval, tolerance=1e-15)
    #print("Entering newton_refine:")
    #@show x

    while diam(x) > tolerance  # avoid problem with tiny floating-point numbers if 0 is a root

        deriv = f_prime(x)
        Nx = N(f, x, deriv)
        Nx = Nx ∩ x
        Nx == x && break
        x = Nx

    end

    Any[(x, :unique)]
end

#newton(f::Function, x::Nothing) = []


newton(f::Function, x::Interval, tolerance=1e-15) = newton(f, D(f), x, 0, tolerance)
 # use automatic differentiation if no derivative function given

function newton(f::Function, f_prime::Function, x::Interval, level::Int=0, tolerance=1e-15)
    
    #print("Entering Newton: ")
    #@show(x, level)

    level >= 30 && return Any[(x, :unknown)]

    isempty(x) && return Any[(x, :empty)]

    # Shall we make sure tolerance>eps(1.0) ?
    z = zero(x.lo)
    tolerance = abs(tolerance)
    if diam(x) < tolerance
        z in f(x) && newton(f, f_prime, x, level+1)
        println("Error: ", z in f(x), " ", x, " ", f(x))
        return Any[(x, :error)]
    end

    #deriv = differentiate(f, x)
    deriv = f_prime(x)

    if !(z in deriv)

        # Nx = N(f, f_prime, x, deriv)
        Nx = N(f, x, deriv)

        isempty(Nx ∩ x) && return Any[(x, :none)]

        Nx ⊆ x && return newton_refine(f, f_prime, Nx)

        # if isthin(x)
        #     println(0 in f(x))
        #     return Any[(x, :unknown)]
        # end

        # bisect:

        #println("Bisecting...")

        m = guarded_mid(x)

        rootsN = vcat(
                    newton(f, f_prime, Interval(x.lo, m), level+1),  # must be careful with rounding of m ?
                    newton(f, f_prime, Interval(m, x.hi), level+1)
                    )

    else  # 0 in deriv; this does extended interval division by hand

        y1 = Interval(deriv.lo, -z)
        y2 = Interval(z, deriv.hi)

        # y1 = N(f, f_prime, x, y1) ∩ x
        # y2 = N(f, f_prime, x, y2) ∩ x
        y1 = N(f, x, y1) ∩ x
        y2 = N(f, x, y2) ∩ x

        rootsN = vcat(
                    newton(f, f_prime, y1, level+1),
                    newton(f, f_prime, y2, level+1)
                    )

    end

    # This cleans-up the tuples with `:none` or `:empty` from the rootsN vector
    rrootsN = Any[]
    for i in 1:length(rootsN)
        tup = copy(rootsN[i])
        (tup[2] == symbol(:none) || tup[2] == symbol(:empty)) && continue
         push!(rrootsN, tup)
    end

    # return sort!(rootsN)
    return sort!(rrootsN)

end

# function process_newton(f::Function, x::Interval)

#     roots = newton(f, x)

#     unique_roots = Interval[]
#     unknown_roots = Interval[]

#     for root in roots
#         @show root
#         if root[2] == :unique
#             push!(unique_roots, root[1])
#         else
#             push!(unknown_roots, root[1])
#         end
#     end

#     sort!(unique_roots)
#     sort!(unknown_roots)

#     unique_roots, unknown_roots
# end

#import Base.show
#show(io::IO, x::Interval) = print(io, "[$(round(float(x.lo), 5)), $(round(float(x.hi), 5))]")
