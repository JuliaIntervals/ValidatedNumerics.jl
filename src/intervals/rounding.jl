## Optimally tight rounding by changing rounding mode:

"""
Transforms
`@round_down(a + b)` to `+(a, b, RoundDown)`
and `@round_down(sin(a))` to `sin(a, RoundDown)`.
"""
macro round_down(ex::Expr)
    if ex.head == :call
        op = ex.args[1]

        if length(ex.args) == 3  # binary operator
            return :( $op($(ex.args[2]), $(ex.args[3]), RoundDown) )

        else  # unary operator
            return :( $op($(ex.args[2]), RoundDown ) )
        end
    end
end

macro round_up(ex::Expr)
    if ex.head == :call
        op = ex.args[1]

        if length(ex.args) == 3  # binary operator
            return :( $op($(ex.args[2]), $(ex.args[3]), RoundUp) )

        else  # unary operator
            return :( $op($(ex.args[2]), RoundUp ) )
        end
    end
end

macro rounding(ex1::Expr, ex2::Expr)
    :(Interval(@round_down($ex1), @round_up($ex2)))
end



import Base: +, -, *, /, sin, sqrt


for mode in (:Down, :Up)

    mode1 = Expr(:quote, mode)
    mode1 = :(::RoundingMode{$mode1})

    mode2 = Symbol("Round", mode)


    for f in (:+, :-, :*, :/)

        @eval begin
            function $f{T<:AbstractFloat}(a::T, b::T, $mode1)
                setrounding(T, $mode2) do
                    $f(a, b)
                end
            end
        end
    end

    for f in (:sqrt,)
        @eval begin
            function $f{T<:AbstractFloat}(a::T, $mode1)
                setrounding(T, $mode2) do
                    $f(a)
                end
            end
        end
    end

end
## Fast but not maximally tight rounding: just use prevfloat and nextfloat:

        # function +{T}(a::T, b::T, ::RoundingMode{:Down})
        #     prevfloat(a + b)
        # end
        #
        # function +{T}(a::T, b::T, ::RoundingMode{:Down})
        #     prevfloat(a + b)
        # end


        # function sin(a, ::RoundingMode{:Down})
        #     prevfloat(sin(a))
        # end
