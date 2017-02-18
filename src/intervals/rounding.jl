# Define rounded versions of elementary functions
# E.g.  +(a, b, RoundDown)
# Some, like sin(a, RoundDown)  are already defined in CRlibm

# Rounding modes:
# - :correct  # correct rounding
# - :fast     # fast rounding by prevfloat and nextfloat  (slightly wider than needed)
# - :none     # no rounding at all for speed


doc"""Choose rounding mode based on environment variable"""

function setup_rounding_mode()
    if haskey(ENV, "VN_ROUNDING")
        rounding_mode = Symbol(ENV["VN_ROUNDING"])

        if rounding_mode ∉ (:correct, :fast, :none)
            throw(ArgumentError("""VN_ROUNDING must be one of `"correct"`, `"fast"`, `"none"`"""))
        end

    else
        rounding_mode = :correct

    end

    global const ROUNDING = rounding_mode
end

setup_rounding_mode()

# CRlibm.setup()

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

    if mode == :Down
        directed = :prevfloat
    else
        directed = :nextfloat
    end


    # arithmetic:
    for f in (:+, :-, :*, :/, :atan2)

        @static if ROUNDING == :correct

            @eval function $f{T<:AbstractFloat}(a::T, b::T, $mode1)
                    setrounding(T, $mode2) do
                        $f(a, b)
                    end
                  end

        elseif ROUNDING == :fast

            @eval $f{T<:AbstractFloat}(a::T, b::T, $mode1) = $directed($f(a, b))

        elseif ROUNDING == :none

            @eval $f{T<:AbstractFloat}(a::T, b::T, $mode1) = $f(a, b)  # no rounding

        end
    end


    # power:
    @static if ROUNDING == :correct

        @eval function ^{T<:AbstractFloat,S}(a::T, b::S, $mode1)
                  setrounding(T, $mode2) do
                      ^(a, b)
                  end
              end

    elseif ROUNDING == :fast

        @eval ^{T<:AbstractFloat,S}(a::T, b::S, $mode1) = $directed(a^b)

    elseif ROUNDING == :none

        @eval ^{T<:AbstractFloat,S}(a::T, b::S, $mode1) = a^b

    end


    # non-CRlibm
    for f in (:sqrt, :inv,
            :tanh, :asinh, :acosh, :atanh)   # these functions not in CRlibm

        @static if ROUNDING == :correct
            @eval function $f{T<:AbstractFloat}(a::T, $mode1)
                      setrounding(T, $mode2) do
                          $f(a)
                      end
                  end

        elseif ROUNDING == :fast

            @eval $f{T<:AbstractFloat}(a::T, $mode1) = $directed($f(a))

        elseif ROUNDING == :none

            @eval $f{T<:AbstractFloat}(a::T, ::RoundingMode) = $f(a)

        end

    end
end

# Functions defined in CRlibm

@static if ROUNDING == :correct
    # CRlibm.setup()

else

    for f in CRlibm.functions

        @static if ROUNDING == :fast

            @eval begin

                # the Float64 definitions are necessary to overwrite the CRlibm ones
                $f(a::Float64, ::RoundingMode{:Down}) = prevfloat($f(a))
                $f(a::Float64, ::RoundingMode{:Up}) = nextfloat($f(a))

                $f{T<:AbstractFloat}(a::T, ::RoundingMode{:Down}) = prevfloat($f(a))
                $f{T<:AbstractFloat}(a::T, ::RoundingMode{:Up}) = nextfloat($f(a))

            end

        elseif ROUNDING == :none

            @eval begin
                $f(a::Float64, ::RoundingMode{:Down}) = $f(a)
                $f(a::Float64, ::RoundingMode{:Up}) = $f(a)

                $f{T<:AbstractFloat}(a::T, ::RoundingMode) = $f(a)
            end

        end
    end

end
