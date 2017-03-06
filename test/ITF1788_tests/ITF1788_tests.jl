
#=
NOTE: The file `ieee1788-constructors.jl`, while it is
included in this directory, is not tested, due to some
lack of functionality
=#

tests = (   "bool",
            "cancel",
            "elem",
            "mul_rev",
            "num",
            "overlap",
            "rec_bool",
            "rev",
            "set"
        )

# addprocs()
# @sync @parallel for test in tests
for test in tests
    filename = "libieeep1788_tests_$test.jl"
    #include(joinpath("ITF1788_tests", filename))
    include(filename)
end
# rmprocs()
