
## Powers
# Integer power of an interval:
function ^(a::Interval, n::Integer)
    n < zero(n) && return reciprocal( a^(-n) )
    n == zero(n) && return one(a)
    n == one(n) && return a
    #
    ## NOTE: square(x) is deprecated in favor of x*x
    if n == 2*one(n)   # this is unnecessary as stands, but  mig(a)*mig(a) is supposed to be more efficient
        return @round(mig(a)^2, mag(a)^2)
    end
    #
    ## even power
    if n%2 == 0
        return @round(mig(a)^n, mag(a)^n)
    end
    ## odd power

    @round(a.lo^n, a.hi^n)
end

^(a::Interval, r::Rational) = (a^(r.num)) ^ (1/r.den)

# Real power of an interval:
function ^(a::Interval, x::Real)
    x == int(x) && return a^(int(x))
    x < zero(x) && return reciprocal( a^(-x) )
    x == 0.5*one(x) && return sqrt(a)
    #
    z = zero(BigFloat)
    z > a.hi && error("Undefined operation; Interval is strictly negative and power is not an integer")
    #
    xInterv = Interval( x )
    diam( xInterv ) >= eps(x) && return a^xInterv
    # xInterv is a thin interval
    domainPow = Interval(z, big(Inf))
    aRestricted = intersect(a, domainPow)
    @round(aRestricted.lo^x, aRestricted.hi^x)

end

# Interval power of an interval:
function ^(a::Interval, x::Interval)
    # Is x a thin interval?
    diam( x ) < eps( mid(x) ) && return a^(x.lo)
    z = zero(BigFloat)
    z > a.hi && error("Undefined operation;\n",
                      "Interval is strictly negative and power is not an integer")
    #
    domainPow = Interval(z, big(Inf))
    aRestricted = intersect(a, domainPow)

    @round(begin
               lolo = aRestricted.lo^(x.lo)
               lohi = aRestricted.lo^(x.hi)
               min( lolo, lohi )
           end,
           begin
               hilo = aRestricted.hi^(x.lo)
               hihi = aRestricted.hi^(x.hi)
               max( hilo, hihi)
           end
           )
end

## sqrt
function sqrt(a::Interval)
    z = zero(BigFloat)
    z > a.hi && error("Undefined operation;\n",
                      "Interval is strictly negative and power is not an integer")
    #
    domainSqrt = Interval(z, big(Inf))
    aRestricted = intersect(a, domainSqrt)

    @round(sqrt(aRestricted.lo), sqrt(aRestricted.hi))

end

## exp
exp(a::Interval) = @round(exp(a.lo), exp(a.hi))

## log
function log(a::Interval)
    z = zero(BigFloat)
    domainLog = Interval(z, big(Inf))
    z > a.hi && error("Undefined log; Interval is strictly negative")
    aRestricted = intersect(a, domainLog)

    @round(log(aRestricted.lo), log(aRestricted.hi))
end
