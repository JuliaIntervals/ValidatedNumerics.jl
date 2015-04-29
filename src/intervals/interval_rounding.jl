
## Macros for directed rounding:

# Use the following empty definitions for rounding types other than Float64:
Base.set_rounding(whatever, rounding_mode) = ()
Base.get_rounding(whatever) = ()

if VERSION > v"0.4-"
    Base.Rounding.get_rounding_raw(whatever) = ()
    Base.Rounding.set_rounding_raw(whatever, rounding_mode) = ()
end


const INTERVAL_ROUNDING = [:narrow]  # or :wide
# TODO: replace by an enum in 0.4

@doc doc"""`get_interval_rounding()` returns the current interval rounding mode.
There are two possible rounding modes:

- :narrow  -- changes the floating-point rounding mode to `RoundUp` and `RoundDown`.
This gives the narrowest possible interval.

- :wide -- Leaves the floating-point rounding mode in `RoundNearest` and uses
`prevfloat` and `nextfloat` to achieve directed rounding. This creates an interval of width 2`eps`.
""" ->

get_interval_rounding() = INTERVAL_ROUNDING[end]

set_interval_rounding(mode) = INTERVAL_ROUNDING[end] = mode  # a symbol



set_interval_rounding(:narrow)


macro with_rounding(T, expr, rounding_mode)
    quote
        with_rounding($T, $rounding_mode) do
            $expr
        end
    end
end


@doc doc"""The `@round` macro creates a rounded interval according to the current interval rounding mode.
It is the main function used to create intervals in the library (e.g. when adding two intervals, etc.).
It uses the interval rounding mode (see get_interval_rounding())""" ->
macro round(T, expr1, expr2)
    #@show "round", expr1, expr2
    quote
        mode = get_interval_rounding()

        if mode == :wide  #works with any rounding mode set, but the result will depend on the rounding mode
            # we assume RoundNearest
            Interval(prevfloat($expr1), nextfloat($expr2))

        else # mode == :narrow
            Interval(@with_rounding($T, $expr1, RoundDown), @with_rounding($T, $expr2, RoundUp))
        end

    end
end

@doc doc"""`@thin_round` possibly saves one operation compared to `@round`.""" ->
macro thin_round(T, expr)
    quote
        mode = get_interval_rounding()

        if mode == :wide  #works with any rounding mode set, but the result will depend on the rounding mode
            # we assume RoundNearest
            temp = $expr  # evaluate the expression
            Interval(prevfloat(temp), nextfloat(temp))

        else # mode == :narrow
            Interval(@with_rounding($T, $expr, RoundDown), @with_rounding($T, $expr, RoundUp))

        end
    end
end


@doc doc"""`big_transf` is used by `@interval` to create intervals from individual elements of different types"""->

big_transf(x::String)    =  @thin_round(@compat parse(BigFloat,x))
# TODO: Check conversion to Float64 from big intervals with > 53 bits. Is the rounding correct?

big_transf(x::String)    =  @thin_round(BigFloat, BigFloat(x))
big_transf(x::MathConst) =  @thin_round(BigFloat, big(x))

big_transf(x::Integer)   =  Interval(BigFloat(x))  # no rounding -- dangerous if very big integer
# but conversion from BigInt to BigFloat with correct rounding seems to be broken anyway # @thin_interval(BigFloat("$x"))
big_transf(x::Rational)  =  big_transf(x.num) / big_transf(x.den)
big_transf(x::Float64)   =  big_transf(rationalize(x))  # NB: converts a float to a rational

big_transf(x::BigInt)    =  @thin_round(BigFloat, convert(BigFloat, x))  # NB: this will give a true thin interval (zero width)

big_transf(x::BigFloat)  =  @thin_round(BigFloat, 1.*x)  # convert to possibly different BigFloat precision
big_transf(x::Interval)  =  @round(BigFloat, convert(BigFloat, x.lo), convert(BigFloat, x.hi)) #convert(Interval{BigFloat}, x)


@doc doc"""`float_transf` is used by `@floatinterval` to create intervals from individual elements of different types"""->

float_transf(x::String)    =  @thin_round(Float64, parsefloat(x))
float_transf(x::MathConst) =  float_transf(big_transf(x)) #convert(Interval{Float64}, @thin_interval(big(x)))   # this should be improved. What happens if BigFloat precision > 53?
# should just define an interval FLOAT_PI

float_transf(x::Integer)   =  Interval(float(x))  # @thin_float_interval(float(x))  # assumes the int is representable
float_transf(x::Rational)  =  float_transf(x.num) / float_transf(x.den)
float_transf(x::Float64)   =  float_transf(rationalize(x))  # NB: converts a float to a rational

float_transf(x::BigInt)    =  float_transf(big_transf(x)) #@round(BigFloat, convert(Float64, x), convert(Float64, x))
float_transf(x::BigFloat)  =  @thin_round(BigFloat, convert(Float64, x)) # @thin_float_interval(convert(Float64, x))  # NB: this will give a true thin interval (zero width)
float_transf(x::Interval)  =  @round(BigFloat, convert(Float64, x.lo), convert(Float64, x.hi)) #convert(Interval{Float64}, x)
# BigFloat to Float64 conversion uses *BigFloat* rounding mode


@doc doc"""`transform` transforms a string by applying the function `transf` to each argument, e.g
`:(x+y)` is transformed to (approximately)
`:(transf(x) + transf(y))`
""" ->
transform(x, f) = :($f($(esc(x))))   # use if x is not an expression

function transform(expr::Expr, f::Symbol)

    if expr.head == :(.)   # e.g. a.lo
        return :($f($(esc(expr))))
    end

    new_expr = copy(expr)


    first = 1  # where to start processing arguments
    if expr.head == :call
        first = 2  # skip operator
    end

    for (i, arg) in enumerate(expr.args)
        i < first && continue
        #@show i,arg

        new_expr.args[i] = transform(arg, f)

    end

    return new_expr
end


@doc doc"""The `@interval` macro is the main way to create an interval of `BigFloat`s.
It converts each expression into a thin interval that is guaranteed to contain the true value passed
by the user in the one or two expressions passed to it.
It takes the hull of the resulting intervals (if necessary, i.e. when given two expressions)
to give a guaranteed containing interval.

Examples:
```
    @interval(0.1)

    @interval(0.1, 0.2)

    @interval(1/3, 1/6)

    @interval(1/3^2)
```
"""->

macro interval(expr1, expr2...)

    expr1 = transform(expr1, :big_transf)

    if isempty(expr2)  # only one argument
        return expr1
    end

    expr2 = transform(expr2[1], :big_transf)

    :(hull($expr1, $expr2))   # BigFloat by default
end

@doc doc"""The `floatinterval` macro constructs an interval with `Float64` entries,
instead of `BigFloat`. It is just a wrapper of the `@interval` macro.""" ->

macro floatinterval(expr1, expr2...)

    expr1 = transform(expr1, :float_transf)

    if isempty(expr2)  # only one argument
        return expr1
    end

    expr2 = transform(expr2[1], :float_transf)

    :(hull($expr1, $expr2))   # BigFloat by default
end



float(x::Interval) = convert(Interval{Float64}, x)
