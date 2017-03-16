using ValidatedNumerics
using Base.Test


@testset "Interval rounding" begin

    x = Interval(0.5)
    @test sin(x) == Interval(0.47942553860420295, 0.479425538604203)

    setrounding(Interval, :fast)
    @test sin(x) == Interval(0.47942553860420295, 0.47942553860420306)

    setrounding(Interval, :none)
    @test sin(x) == Interval(0.479425538604203, 0.479425538604203)

    setrounding(Interval, :correct)
    @test sin(x) == Interval(0.47942553860420295, 0.479425538604203)

end
