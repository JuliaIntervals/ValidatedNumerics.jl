# This file is part of the ValidatedNumerics.jl package; MIT licensed

## Precision:

set_interval_precision(::Type{Float64}, prec=-1) = parameters.precision_type = Float64


function set_interval_precision(::Type{BigFloat}, precision::Integer=256)
    set_bigfloat_precision(precision)

    parameters.precision_type = BigFloat
    parameters.precision = precision
    parameters.pi = make_interval(BigFloat, pi)

    precision
end

function with_interval_precision(f::Function, precision::Integer=256)
    old_interval_precision = get_interval_precision()
    set_interval_precision(precision)
    try
        return f()
    finally
        set_interval_precision(old_interval_precision)
    end
end

set_interval_precision(precision) = set_interval_precision(BigFloat, precision)
set_interval_precision(t::Tuple) = set_interval_precision(t...)

get_interval_precision() =
    parameters.precision_type == Float64 ? (Float64, -1) : (BigFloat, parameters.precision)


const float_interval_pi = make_interval(Float64, pi)  # does not change

pi_interval(::Type{BigFloat}) = parameters.pi
pi_interval(::Type{Float64})  = float_interval_pi
