type DisplayParameters
    interval_display::Symbol
    decorations::Bool
    precision::Int
end

const display_params = DisplayParameters(:standard, false, 6)



function display_mode(;decorations=nothing, interval_display=nothing, precision::Int=-1)
    if interval_display != nothing
        display_params.interval_display = interval_display
    end

    if decorations != nothing
        display_params.decorations = decorations
    end

    if precision >= 0
        display_params.precision = precision
    end
end


function format(x::Float64, prec::Int)
    fmt = "%.$(prec)g"
    @eval @sprintf($fmt, $x)
    # hack from https://github.com/JuliaLang/julia/issues/4248
    # Replace with Formatting.jl if supports %g
end

format(x::Float64) = format(x, display_params.precision)

function representation(a::Interval)
    if isempty(a)
        return "∅"
    end

    interval_display = display_params.interval_display

    local output

    if interval_display == :standard
        aa = format(a.lo)
        bb = format(a.hi)

        output = "[$aa, $bb]"
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

show(io::IO, a::Interval) = print(io, representation(a))

function subscriptify(n::Int)
    subscript_digits = [c for c in "₀₁₂₃₄₅₆₇₈₉"]
    dig = reverse(digits(n))
    join([subscript_digits[i+1] for i in dig])
end
