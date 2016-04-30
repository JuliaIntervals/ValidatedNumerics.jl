type DisplayParameters
    interval_display::Symbol
    decorations::Bool
    precision::Int
end

const display_params = DisplayParameters(:standard, false, 6)



function display_mode(;decorations=nothing, interval_display=nothing, precision=-1)
    if interval_display != nothing
        display_params.interval_display = interval_display
    end

    if decorations != nothing
        display_params.decorations = decorations
    end

    if precision >= 0
        display_params.precision = precision
        change_precision(precision)
    end
end



## Output

function change_precision(prec::Int)
    prec = Float64(prec)
    prec = Int(prec)
    #display_params.float_format = "%.$(prec)g"
    fmt = "%.$(prec)g"
    @eval format(x::Float64) = (@sprintf($fmt, x))
    # creates global "format" function; add to __init__
end
change_precision(6)  # move to __init__


# function format(x::Float64, prec::Int)
#     fmt = "%.$(prec)g"
#     @eval @sprintf($fmt, $x)
# end
#
# format(x::Float64) = format(x, display_params.precision)

function representation(a::Interval)
    if isempty(a)
        return "∅"
    end

    interval_display = display_params.interval_display

    local output

    if interval_display == :standard
        #aa = format(a.lo)
        #bb = format(a.hi)

        # the following is a hack to make sure that format is not inlined:
        # make it type unstable
        aa = rand() < 2 ? a.lo : nothing
        bb = rand() < 2 ? a.hi : nothing

        aaa = format(aa)
        bbb = format(bb)
        #output = "[$(@noinline format(a.lo)), $(@noinline format(a.hi))]"
        output = "[$aaa, $bbb]"
        # prec = display_params.precision
        # fmt = "[%.$(prec)g, %.$(prec)g]"
        # output = @eval @sprintf($fmt, $(a.lo), $(a.hi))

        output = replace(output, "inf", "∞")
        output = replace(output, "Inf", "∞")

    elseif interval_display == :reproducible
        output = "Interval($(a.lo), $(a.hi))"

    elseif interval_display == :midpoint_radius
        output = "$(mid(a)) ± $(diam(a)/2)"
    end

    output
end

function representation(a::Interval{BigFloat})
    if interval_display == :standard
        string( invoke(representation, (Interval,), a),
                    subscriptify(precision(a.lo)) )

    elseif interval_display == :reproducible
        invoke(representation, (Interval,), a)
    end
end

function representation(a::DecoratedInterval)
    interval = representation(interval_part(a))

    if display_params.decorations
        string(interval, "_", decoration(a))
    else
        interval
    end

end

show(io::IO, a::Interval) = print(io, representation(a))
show(io::IO, a::DecoratedInterval) = print(io, representation(a))

function subscriptify(n::Int)
    subscript_digits = [c for c in "₀₁₂₃₄₅₆₇₈₉"]
    dig = reverse(digits(n))
    join([subscript_digits[i+1] for i in dig])
end

function round(x::Real, digits::Int, rounding_mode::RoundingMode)
    y = float(x)
    og = oftype(y, 10)^digits

    r = round(y * og, rounding_mode) / og

    if !isfinite(r)
        if digits > 0
            return y

        elseif y > 0
            return zero(y)

        elseif y < 0
            -zero(y)

        else
            return y
        end

    end

    r
end

# round to given number of signficant digits
# basic structure taken from base/mpfr.jl
function round_string(x::BigFloat, digits::Int, r::RoundingMode)

    lng = digits + Int32(8)
    buf = Array(UInt8, lng + 1)

    lng = ccall((:mpfr_snprintf,:libmpfr), Int32,
    (Ptr{UInt8}, Culong,  Ptr{UInt8}, Int32, Ptr{BigFloat}...),
    buf, lng + 1, "%.$(digits)R*g", Base.MPFR.to_mpfr(r), &x)

    return bytestring(pointer(buf))
end

round_string(x::Real, digits::Int, r::RoundingMode) = round(big(x), digits, r)
