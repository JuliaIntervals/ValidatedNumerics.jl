if VERSION >= v"0.5.0-dev+7720"
    using Base.Test
else
    using BaseTestNext
    const Test = BaseTestNext
end
using ValidatedNumerics


# Interval tests:

setdisplay(:full)

# This is done like this so the master worker precompiles
cd("test")
include("display_tests/display.jl") # display tests

info("Parallelizing tests")
testfiles = (
    "interval_tests/intervals.jl",
    "multidim_tests/multidim.jl",
    "decoration_tests/decoration_tests.jl",
    "root_finding_tests/root_finding.jl", # root finding tests
    )

addprocs()
@sync @parallel for tfile in testfiles
    include(tfile)
end

# ITF1788 tests; parallelized separately to have more processors
info("Test ITF1788 suite")
include("ITF1788_tests/ITF1788_tests.jl")
rmprocs()
