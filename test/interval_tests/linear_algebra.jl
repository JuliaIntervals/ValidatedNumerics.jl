using ValidatedNumerics
using Base.Test



A = [ 2..4   -2..1
     -1..2    2..4]

b = [-2..2
     -2..2]


@testset "Linear algebra with intervals tests" begin

    @test A * b == [-12..12
                    -12..12]

    # Example from Moore et al., Introduction to Interval Analysis (2009), pg. 88:

    if VERSION <= v"0.5"
    @test A \ b == [-5..5
                    -4..4]
    else
        @test_broken A \ b == [-5..5
                               -4..4]
                    end

end
