using ValidatedNumerics
using Base.Test

# using Suppressor

setformat(:full)

# @suppress begin

# @testset "Interval rounding" begin

# NB: Due to "world age" problems, the following is not a @testset

setrounding(Interval, :correct)
x = Interval(0.5)
@testset "Correct rounding" begin
    @test sin(x) == Interval(0.47942553860420295, 0.479425538604203)
end

setrounding(Interval, :fast)
@testset "Fast rounding" begin
    @test sin(x) == Interval(0.47942553860420295, 0.47942553860420306)
end

setrounding(Interval, :none)
@testset "No rounding" begin
    @test sin(x) == Interval(0.479425538604203, 0.479425538604203)
end

setrounding(Interval, :correct)
@testset "Back to correct rounding" begin
    @test sin(x) == Interval(0.47942553860420295, 0.479425538604203)
end

setrounding(Interval, :correct)
@testset "Arithmetic" begin
    @test +(0.1, 0.5, RoundUp) == 0.6000000000000001
    @test +(0.1, 0.5, RoundDown) == 0.6
end

setrounding(Interval, :errorfree)
@testset "Arithmetic" begin
    @test +(0.1, 0.5, RoundUp) == 0.6000000000000001
    @test +(0.1, 0.5, RoundDown) == 0.6
end

setformat(:standard)

# end
# end
