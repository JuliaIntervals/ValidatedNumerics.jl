using ValidatedNumerics
using Base.Test

@testset "Complex interval operations" begin
    a = @interval 1im
    @inferred a == Complex{ValidatedNumerics.Interval{Float64}}
    @test a ==  Interval(0) + Interval(1)*im
    @test a * a == Interval(-1)
    @test a + a == Interval(2)*im
    @test a - a == 0
    @test a / a == 1
    @test a^2 == -1
end
