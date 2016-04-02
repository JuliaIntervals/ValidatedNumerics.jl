using ValidatedNumerics
using FactCheck

facts("Misc tests") do
    @fact BigFloat(pi) == big(pi) --> true
    @fact pi < pi --> false
    @fact pi > pi --> false
end

facts("Rationalize tests") do
    for rounding_mode in (RoundNearest, RoundDown, RoundUp)
        a = setrounding(Float64, rounding_mode) do
            # @compat a = parse(Float64, "0.1")
            1 / 10
        end

        #println("Rationalizing a=$a")
        @fact ValidatedNumerics.old_rationalize(a) == 1//10 --> true

    end
end

facts("Aliases tests") do
    IEEE_to_julia = ValidatedNumerics.IEEE_to_julia
    for IEEE_name in keys(IEEE_to_julia)
        julia_name = ValidatedNumerics.alias(IEEE_name)
        @fact julia_name --> IEEE_to_julia[IEEE_name]
    end
end
