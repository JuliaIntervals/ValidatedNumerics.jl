# Define rounded versions of elementary functions
# E.g.  +(a, b, RoundDown)
# Some, like sin(a, RoundDown)  are already defined in CRlibm

# Rounding types:
# - :correct  # correct rounding
# - :fast     # fast rounding by prevfloat and nextfloat  (slightly wider than needed)
# - :none     # no rounding at all for speed

# "Traits-based" design:
# Define functions like
# sin(::RoundingType{:correct}, x, ::RoundingMode)
# sin(::RoundingType{:fast}, x, ::RoundingMode)
# sin(::RoundingType{:none}, x, ::RoundingMode)

# Then define e.g.
# sin(x, r::RoundingMode) = sin(RoundingType{:correct}, x, r)


doc"""Choose rounding mode based on environment variable"""

immutable RoundingType{T} end


# Functions that are the same for all rounding types:
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


    # binary functions:
    for f in (:+, :-, :*, :/, :atan2)

        @eval function $f{T<:AbstractFloat}(::RoundingType{:correct},
                                            a::T, b::T, $mode1)
                    setrounding(T, $mode2) do
                        $f(a, b)
                    end
                end

        @eval $f{T<:AbstractFloat}(::RoundingType{:fast},
                                    a::T, b::T, $mode1) = $directed($f(a, b))

        @eval $f{T<:AbstractFloat}(::RoundingType{:none},
                                    a::T, b::T, $mode1) = $f(a, b)

    end


    # power:

    @eval function ^{T<:AbstractFloat,S}(::RoundingType{:correct},
                                        a::T, b::S, $mode1)
                  setrounding(T, $mode2) do
                      ^(a, b)
                  end
           end

    @eval ^{T<:AbstractFloat,S}(::RoundingType{:fast},
                                a::T, b::S, $mode1) = $directed(a^b)

    @eval ^{T<:AbstractFloat,S}(::RoundingType{:none},
                                a::T, b::S, $mode1) = a^b


    # functions not in CRlibm:
    for f in (:sqrt, :inv, :tanh, :asinh, :acosh, :atanh)

        @eval function $f{T<:AbstractFloat}(::RoundingType{:correct},
                                            a::T, $mode1)
                            setrounding(T, $mode2) do
                                $f(a)
                            end
               end


        @eval $f{T<:AbstractFloat}(::RoundingType{:fast},
                                    a::T, $mode1) = $directed($f(a))

        @eval $f{T<:AbstractFloat}(::RoundingType{:none},
                                    a::T, ::RoundingMode) = $f(a)


    end


    # Functions defined in CRlibm

    for f in CRlibm.functions
        @eval $f{T<:AbstractFloat}(::RoundingType{:correct},
                                a::T, $mode1) = CRlibm.$f(a, $mode2)

        @eval $f{T<:AbstractFloat}(::RoundingType{:fast},
                                    a::T, $mode1) = $directed($f(a))

        @eval $f{T<:AbstractFloat}(::RoundingType{:none},
                                    a::T, ::RoundingMode) = $f(a)

    end
end


function setrounding(::Type{Interval}, mode1::Symbol)
    mode2 = Meta.quot(mode1)
    # binary:

    for f in (:+, :-, :*, :/, :^, :atan2)
        @eval $f{T<:AbstractFloat}(a::T, b::T, $mode1) = $f(RoundingType{$mode2}(), a, b, $mode1)
    end

    for f in (:sqrt, :inv, :tanh, :asinh, :acosh, :atanh)
        @eval $f{T<:AbstractFloat}(a::T, $mode1) = $f(RoundingType{$mode2}(), a, $mode1)
    end

    for f in CRlibm.functions
        @eval $f{T<:AbstractFloat}(a::T, $mode1) = $f(RoundingType{$mode2}(), a, $mode1)
    end
end


setrounding(Interval, :correct)
