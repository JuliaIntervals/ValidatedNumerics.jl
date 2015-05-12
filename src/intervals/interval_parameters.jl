using ValidatedNumerics

import ValidatedNumerics.make_interval


type IntervalParameters

    precision_type::Type
    precision::Int

    rounding_mode::RoundingMode

    pi::Interval{BigFloat}
end

const float_pi = make_interval(Float64, pi)  # does not change

# default values:
const interval_parameters = # IntervalParameters() =
    IntervalParameters(
        Float64,
        256,
        RoundNearest,
        make_interval(BigFloat, pi),
    )


set_interval_precision(::Type{Float64}) =  interval_parameters.precision_type = Float64

#set_interval_precision(256)

function set_interval_precision(::Type{BigFloat}, prec::Int=256)
    set_bigfloat_precision(prec)

    interval_parameters.precision_type = BigFloat
    interval_parameters.precision = prec
    interval_parameters.pi = make_interval(BigFloat, pi)
end

get_interval_precision() =
    interval_parameters.precision_type ==
            Float64 ? (Float64, -1) :  (BigFloat, interval_parameters.precision)


set_interval_precision(prec) = set_interval_precision(BigFloat, prec)

set_interval_precision(Float64)


get_pi(::Type{BigFloat}) = interval_parameters.pi
get_pi(::Type{Float64}) = float_pi

#get_pi() = get_pi(interval_parameters.precision_type)  # type unstable
