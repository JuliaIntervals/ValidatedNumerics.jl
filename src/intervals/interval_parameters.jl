using ValidatedNumerics

type IntervalParameters

    precision_type::Type
    precision::Int

    rounding_mode::RoundingMode

    pi::Interval{BigFloat}
end

const float_pi = make_interval(Float64, pi)  # does not change

# default values:
IntervalParameters() =
    IntervalParameters(
        Float64,
        256,
        RoundNearest,
        @interval(pi),
    )


const interval_parameters = IntervalParameters()


function set_interval_precision(T::Type, prec::Int=256)
    interval_parameters.precision_type = T

    if T==BigFloat
        interval_parameters.precision = prec
        set_bigfloat_precision(prec)
        interval_parameters.big_pi = @interval(pi)
    end
end

get_interval_precision() =
    interval_parameters.precision_type == Float64 ? (Float64, -1)
                                                  : (BigFloat, interval_parameters.precision)


set_interval_precision(prec) = set_interval_precision(BigFloat, prec)

get_pi(::Type{BigFloat}) = interval_parameters.pi
get_pi(::Type{Float64}) = float_pi

get_pi() = get_pi(interval_parameters.precision_type)
