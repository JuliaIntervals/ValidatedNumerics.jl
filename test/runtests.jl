
using ValidatedNumerics
using Base.Test

# Interval tests:

setformat(:full)

include("interval_tests/intervals.jl")
include("error_free_arithmetic_tests/error_free_arithmetic_tests.jl")
include("decoration_tests/decoration_tests.jl")
include("display_tests/display.jl")
include("multidim_tests/multidim.jl")

using ValidatedNumerics.RootFinding
include("root_finding_tests/root_finding.jl")
include("ITF1788_tests/ITF1788_tests.jl")
