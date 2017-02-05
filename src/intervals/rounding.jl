# Define rounded versions of elementary functions
# E.g.  +(a, b, RoundDown)
# Some, like sin(a, RoundDown)  are already defined in CRlibm

# Rounding modes:
# - :correct  # correct rounding
# - :fast     # fast rounding by prevfloat and nextfloat  (slightly wider than needed)
# - :none     # no rounding at all for speed


function setup_rounded_functions(ROUNDING)

    if ROUNDING ∉ (:correct, :fast, :none)
        throw(ArgumentError("ROUNDING must be one of `:correct`, `:fast`, `:none`"))
    end

    @eval begin
        # unary minus:
        -{T<:AbstractFloat}(a::T, ::RoundingMode) = -a  # ignore rounding

        # zero:
        zero{T<:AbstractFloat}(a::Interval{T}, ::RoundingMode) = zero(T)
        zero{T<:AbstractFloat}(::Type{T}, ::RoundingMode) = zero(T)

        convert(::Type{BigFloat}, x, rounding_mode::RoundingMode) = setrounding(BigFloat, rounding_mode) do
            convert(BigFloat, x)
        end

        parse{T}(::Type{T}, x, rounding_mode::RoundingMode) = setrounding(T, rounding_mode) do
            parse(T, x)
        end


        sqrt{T<:Rational}(a::T, rounding_mode::RoundingMode) = setrounding(float(T), rounding_mode) do
            sqrt(float(a))
        end

    end

    # no-ops for rational rounding:
    for f in (:+, :-, :*, :/)
        @eval $f{T<:Rational}(a::T, b::T, ::RoundingMode) = $f(a, b)
    end



    for mode in (:Down, :Up) #, T in (:Float64)

        mode1 = Expr(:quote, mode)
        mode1 = :(::RoundingMode{$mode1})

        mode2 = Symbol("Round", mode)


        # arithmetic:
        for f in (:+, :-, :*, :/, :atan2)

            if ROUNDING == :correct
                @eval function $f{T<:AbstractFloat}(a::T, b::T, $mode1)
                        setrounding(T, $mode2) do
                            $f(a, b)
                        end
                      end

            elseif ROUNDING == :fast
                @eval begin
                    function $f{T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:Down})
                        prevfloat($f(a, b))
                    end

                    function $f{T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:Up})
                        nextfloat($f(a, b))
                    end
                end

            elseif ROUNDING == :none
                @eval $f{T<:AbstractFloat}(a::T, b::T, $mode1) = $f(a, b)  # no rounding

            end
        end


        # power:
        if ROUNDING == :correct

            @eval function ^{T<:AbstractFloat,S}(a::T, b::S, $mode1)
                      setrounding(T, $mode2) do
                          ^(a, b)
                      end
                  end

        elseif ROUNDING == :fast

            @eval begin
                function ^{T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:Down})
                    prevfloat(a^b)
                end

                function ^{T<:AbstractFloat}(a::T, b::T, ::RoundingMode{:Up})
                    nextfloat(a^b)
                end
            end

        elseif ROUNDING == :none

            @eval ^{T<:AbstractFloat}(a::T, b::T, $mode1) = a^b

        end


        # non-CRlibm
        for f in (:sqrt, :inv,
                :tanh, :asinh, :acosh, :atanh)   # these functions not in CRlibm

            if ROUNDING == :correct
                @eval function $f{T<:AbstractFloat}(a::T, $mode1)
                          setrounding(T, $mode2) do
                              $f(a)
                          end
                      end

            elseif ROUNDING == :fast
                @eval begin
                          function $f{T<:AbstractFloat}(a::T, ::RoundingMode{:Down})
                              prevfloat($f(a))
                          end

                          function $f{T<:AbstractFloat}(a::T, ::RoundingMode{:Up})
                              nextfloat($f(a))
                          end
                      end

            elseif ROUNDING == :none

                @eval $f{T<:AbstractFloat}(a::T, ::RoundingMode) = $f(a)

            end

        end
    end

    # Functions defined in CRlibm
    if ROUNDING == :correct
        CRlibm.setup()

    else

        for f in CRlibm.functions

            if ROUNDING == :fast

                @eval begin
                    function $f{T<:AbstractFloat}(a::T, ::RoundingMode{:Down})
                        prevfloat($f(a))
                    end

                    function $f{T<:AbstractFloat}(a::T, ::RoundingMode{:Up})
                        nextfloat($f(a))
                    end
                end

            elseif ROUNDING == :none

                @eval $f{T<:AbstractFloat}(a::T, ::RoundingMode) = $f(a)

            end
        end

    end
end
