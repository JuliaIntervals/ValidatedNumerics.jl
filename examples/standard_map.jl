using ValidatedNumerics

import Base.mod2pi

function standard_map(X::IntervalBox, k = 1.0)
    p, θ = X

    p′ = p + k*sin(θ)
    @show p′
    θ′ = mod2pi( θ + p′ )
    p′ = mod2pi(p′)

    @show p′, θ′
    @show typeof(p′), typeof(θ′)

    IntervalBox(p′, θ′)
end

function IntervalBox{T}(X::Vector{BareInterval{T}}, Y::Vector{BareInterval{T}})
    vec([IntervalBox(x, y) for x in X, y in Y])
end

function iterate(f, n, x)
    for i in 1:n
        x = f(x)
    end
    x
end


import Base.mod
function mod(X::BareInterval, width::Real)


    @show X, width

    X /= width

    if diam(X) >= 1.

        return [BareInterval(0, 1) * width]
    end

    a = X.lo - floor(X.lo)
    b = X.hi - floor(X.hi)

    if a < b
        return [BareInterval(a, b)*width]

    end

    return [BareInterval(0, b)*width, BareInterval(a, 1)*width]

end


function mod(X::IntervalBox, width::Real)
    x, y = X

    xx = mod(x, width)
    yy = mod(y, width)

    vec([IntervalBox(x, y) for x in xx, y in yy])
end


mod2pi{T}(x::BareInterval{T}) = mod(x, ValidatedNumerics.two_pi(T))

mod2pi{T}(X::Vector{BareInterval{T}}) = vcat(map(mod2pi, X)...)
