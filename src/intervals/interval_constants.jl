type IntervalConstants
    big_pi::Interval{BigFloat}
    float_pi::Interval{Float64}
end

const interval_constants = IntervalConstants(@interval(pi), @floatinterval(pi))

function set_interval_precision(prec::Int)
    set_bigfloat_precision(prec)
    interval_constants.big_pi = @interval(pi)
end

