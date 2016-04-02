# Aliases for function names from the IEEE Std 1788-2015 (https://standards.ieee.org/findstds/standard/1788-2015.html)

# Includes only those functions whose names differ in Julia

const IEEE_to_julia = Dict{Symbol, Symbol}()
const julia_to_IEEE = Dict{Symbol, Symbol}()

doc"Create alias of IEEE function name (a symbol) to Julia function name"

alias(x::Symbol, y::Expr) = alias(x, y.args[1])

function alias(IEEE_name::Symbol, julia_name::Symbol)
    IEEE_to_julia[IEEE_name] = julia_name
    julia_to_IEEE[julia_name] = IEEE_name
end

function alias(name::Symbol)
    try
        return IEEE_to_julia[name]
    catch
        try
            return julia_to_IEEE[name]
        end
    end

    throw(ArgumentError("$name is not a valid alias"))
end

macro alias(ex1, ex2...)
    if length(ex2) > 0
        ex2 = ex2[1]
        #@show ex1, ex2
        alias(ex1, ex2)
    else
        #return Expr(:quote, alias(:(esc($ex1))))
        return Expr(:quote, alias(ex1))
    end

    nothing
end

## Table from section 9 of the Standard document (page 28)
@alias neg :(-)
@alias add :(+)
@alias sub :(-)
@alias mul :(*)
@alias div :(/)
@alias recip inv

@alias pown :(^)
@alias pow :(^)

# @alias inf infimum
@alias sup supremum
@alias wid diam
@alias rad radius
# @alias equal :(=)
@alias subset issubset
@alias disjoint isdisjoint

@alias intersection intersect
@alias convexHull hull

## Table of required reverse functions on page 37:
# sqrRev, absRev, pownRev, sinRev, cosRev, tanRev, coshRev,
# mulRev, powRev1, powRev2, atan2Rev1, atan2Rev2, mulRevToPair


## Functions with same name:
# for f in (:exp, :exp2, :exp10, :log, :log2, :log10,
#     :sin, :cos, :tan, :asin, :acos, :atan, :atan2,
#     :sinh, :cosh, :tanh, :asinh, :acosh, :atanh,
#     :sign, :ceil, :floor, :trunc, :roundTiesToEven, :roundTiesToAway,
#     :abs, :min, :max,
#     :inf
