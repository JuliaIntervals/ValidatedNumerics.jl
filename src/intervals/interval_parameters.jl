using ValidatedNumerics

type IntervalParameters

    precision_type::Type
    bigfloat_precision::Int

    rounding_mode::RoundingMode

    big_pi::Interval{BigFloat}
    float_pi::Interval{Float64}
end

# default values:
IntervalParameters() =
    IntervalParameters(
        Float64,
        256,
        RoundNearest,
        @interval(pi),
        @floatinterval(pi)
    )


const interval_parameters = IntervalParameters()


function set_interval_precision(T::Type, prec::Int=256)
    interval_parameters.precision_type = T

    if T==BigFloat
        interval_parameters.bigfloat_precision = prec
        set_bigfloat_precision(prec)
        interval_constants.big_pi = @interval(pi)
    end
end
