# Version of `rationalize` from 0.3 that works correctly with rounding modes

function old_rationalize{T<:Integer}(::Type{T}, x::FloatingPoint; tol::Real=eps(x))
    if isnan(x);       return zero(T)//zero(T); end
    if x < typemin(T); return -one(T)//zero(T); end
    if typemax(T) < x; return  one(T)//zero(T); end
    tm = x < 0 ? typemin(T) : typemax(T)
    z = x*tm
    if z <= 0.5 return zero(T)//one(T) end
    if z <= 1.0 return one(T)//tm end
    y = x
    a = d = 1
    b = c = 0
    while true
        f = trunc(Int, y); y -= f
        p, q = f*a+c, f*b+d
        typemin(T) <= p <= typemax(T) &&
        typemin(T) <= q <= typemax(T) || break
        0 != sign(a)*sign(b) != sign(p)*sign(q) && break
        a, b, c, d = p, q, a, b
        if y == 0 || abs(a/b-x) <= tol
            break
        end
        y = inv(y)
    end
    return convert(T,a)//convert(T,b)
end

old_rationalize(x::Union(Float64,Float32); tol::Real=eps(x)) = old_rationalize(Int, x, tol=tol)
