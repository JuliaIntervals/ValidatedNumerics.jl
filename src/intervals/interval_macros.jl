
## Macros for directed rounding:

# Use the following empty definitions for rounding types other than Float64:
Base.set_rounding(whatever, rounding_mode) = ()
Base.get_rounding(whatever) = ()

if VERSION > v"0.4-"
    Base.Rounding.get_rounding_raw(whatever) = ()
    Base.Rounding.set_rounding_raw(whatever, rounding_mode) = ()
end

#Base.with_rounding(f, whatever, rounding_mode) = whatever

macro rounding(T, expr, rounding_mode)

    quote
        with_rounding($T, $rounding_mode) do
            $expr
        end
    end
end


macro round(T, expr1, expr2)
    quote
        Interval(@rounding($T, $expr1, RoundDown), @rounding($T, $expr2, RoundUp))
    end
end


macro thin_interval(expr)
    quote
        @round(BigFloat, $expr, $expr)
    end
end



## Wrap user input for correct rounding:
# These transf functions are called after the initial @interval macro has been expanded

transf(a::MathConst) =  @thin_interval(big(a))
transf(a::BigFloat)  =  @thin_interval(a)
transf(a::Number)    =  @thin_interval(BigFloat("$a"))


@doc doc"""`transform` transforms a string by applying the function `transf` to each argument, e.g
`:(x+y)` is transformed to (approximately)
`:(transf(x) + transf(y))`
""" ->
transform(x::Symbol) = :(transf($(esc(x))))
transform(x::Number) = :(transf($(esc(x))))

function transform(expr::Expr)

    if expr.head == :(.)   # e.g. a.lo
        return :(transf($(esc(expr))))
    end

    new_expr = copy(expr)


    start = 1
    if expr.head == :call
        start = 2  # omit operator
    end

    for (i, arg) in enumerate(expr.args)
        i < start && continue
        #@show i,arg

        new_expr.args[i] = transform(arg)

    end

    return new_expr
end


@doc doc"""The `@interval` macro is the main way to create an interval of `BigFloat`s.
It converts each expression into a small interval that is guaranteed to contain the true value passed
by the user in the one or two expressions passed to it.
It takes the hull of the resulting two intervals to give a guaranteed containing interval.
"""->

macro interval(expr1, expr2...)

    expr1 = transform(expr1)

    if isempty(expr2)  # only one argument
        return expr1
    end

    expr2 = transform(expr2[1])

    :(hull($expr1, $expr2))   # BigFloat by default
end


## Construct interval with Float64s instead of BigFloats:

function float(x::Interval)
    # @round(BigFloat, convert(Float64, x.lo), convert(Float64, x.hi))
    convert(Interval{Float64}, x)
end

macro floatinterval(expr1, expr2...)
    if isempty(expr2)
        expr2 = expr1
    else
        expr2 = expr2[1]
    end

    :(float(@interval($expr1, $expr2)))
end
