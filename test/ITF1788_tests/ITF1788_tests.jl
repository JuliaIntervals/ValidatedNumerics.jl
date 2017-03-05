
#=
NOTE: The file `ieee1788-constructors.jl`, while it is
included in this directory, is not tested, due to some
lack of functionality
=#

testfiles = (
    "libieeep1788_tests_bool.jl", "libieeep1788_tests_cancel.jl",
    "libieeep1788_tests_elem.jl", "libieeep1788_tests_mul_rev.jl",
    "libieeep1788_tests_num.jl", "libieeep1788_tests_overlap.jl",
    "libieeep1788_tests_rec_bool.jl", "libieeep1788_tests_rev.jl",
    "libieeep1788_tests_set.jl"
)

@sync @parallel for tf in testfiles
    include("ITF1788_tests/" * tf)
end
